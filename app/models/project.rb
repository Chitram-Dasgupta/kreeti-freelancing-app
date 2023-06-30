class Project < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :user

  has_many :bids, dependent: :destroy
  has_many :project_categories, dependent: :destroy
  has_many :categories, through: :project_categories

  has_one_attached :design_document
  has_one_attached :srs_document

  validates :title, presence: true

  enum visibility: { pub: 0, priv: 1 }

  delegate :email, to: :user

  scope :recent_by_user, ->(user) { where(user:).order(created_at: :desc).limit(5) }

  scope :recent, -> { order(created_at: :desc).limit(5) }

  def as_indexed_json(_options = {})
    as_json(
      only: %i[id title description],
      include: { categories: { only: :name } }
    )
  end

  settings index: { max_ngram_diff: 10 }, analysis: {
    filter: {
      ngram_filter: {
        type: 'ngram',
        min_gram: 2,
        max_gram: 12
      }
    },
    analyzer: {
      index_ngram_analyzer: {
        type: 'custom',
        tokenizer: 'standard',
        filter: %w[lowercase ngram_filter]
      },
      search_ngram_analyzer: {
        type: 'custom',
        tokenizer: 'standard',
        filter: ['lowercase']
      }
    }
  } do
    mapping do
      indexes :categories, type: 'nested' do
        indexes :name, type: 'text', analyzer: 'index_ngram_analyzer', search_analyzer: 'search_ngram_analyzer'
      end
    end
  end

  def self.all_skills
    ['Javascript developer', 'Ruby developer', 'Elixir developer', 'Typescript developer',
     'Python developer', 'Android developer', 'Java developer', 'Graphic designer',
     'HTML/CSS developer', 'System admin', 'Data scientist', 'Technical writer']
  end

  def bid_awarded?
    bids.where(bid_status: :awarded).exists?
  end

  def self.search_projects(category_name)
    search_definition = {
      query: {
        bool: {
          must: [
            {
              nested: {
                path: 'categories',
                query: {
                  match: {
                    'categories.name': category_name
                  }
                }
              }
            }
          ]
        }
      }
    }

    __elasticsearch__.search(search_definition)
  end
end
