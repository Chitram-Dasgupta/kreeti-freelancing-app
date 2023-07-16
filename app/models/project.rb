# frozen_string_literal: true

class Project < ApplicationRecord
  include Searchable

  def as_indexed_json(_options = {})
    as_json(
      only: %i[id title description visibility],
      include: { categories: { only: :name } }
    )
  end

  settings index: { number_of_shards: 1 } do
    mapping dynamic: 'false' do
      indexes :visibility
      indexes :id, type: :integer
      indexes :title, type: :text
      indexes :description, type: :text
      indexes :categories, type: :nested do
        indexes :name
      end
    end
  end

  paginates_per 12

  enum visibility: { pub: 0, priv: 1 }

  belongs_to :user

  has_many :bids, dependent: :destroy
  has_many :project_categories, dependent: :destroy
  has_many :categories, through: :project_categories

  has_one_attached :design_document
  has_one_attached :srs_document

  validates :title, presence: true

  delegate :username, to: :user

  scope :visible_to, ->(user) { user&.role == 'admin' ? all : where.not(visibility: 'priv').or(where(user:)) }

  default_scope { order(created_at: :desc) }

  def self.all_skills
    ['Javascript developer', 'Ruby developer', 'Elixir developer', 'Typescript developer',
     'Python developer', 'Android developer', 'Java developer', 'Graphic designer',
     'HTML/CSS developer', 'System admin', 'Data scientist', 'Technical writer']
  end

  # rubocop:disable Metrics/MethodLength
  def self.search_projects(category_name)
    search_definition = {
      size: 100,
      query: {
        bool: {
          must: [
            {
              nested: {
                path: 'categories',
                query: {
                  match_phrase: {
                    'categories.name': category_name
                  }
                }
              }
            },
            {
              match: {
                visibility: 'pub'
              }
            }
          ]
        }
      }
    }

    __elasticsearch__.search(search_definition)
  end
  # rubocop:enable Metrics/MethodLength

  def bid_awarded?
    bids.exists?(bid_status: 'accepted')
  end

  def accepted_bid_freelancer
    bids.where(bid_status: :accepted).first&.user
  end
end
