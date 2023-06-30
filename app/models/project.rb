class Project < ApplicationRecord
  include Searchable

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

  def self.all_skills
    ['Javascript developer', 'Ruby developer', 'Elixir developer', 'Typescript developer',
     'Python developer', 'Android developer', 'Java developer', 'Graphic designer',
     'HTML/CSS developer', 'System admin', 'Data scientist', 'Technical writer']
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

  def bid_awarded?
    bids.where(bid_status: :awarded).exists?
  end
end
