# frozen_string_literal: true

class Project < ApplicationRecord
  include Searchable

  def as_indexed_json(_options = {})
    as_json(
      include: { categories: { only: :name } },
      methods: :has_awarded_bid
    )
  end

  enum visibility: { pub: 0, priv: 1 }

  belongs_to :user

  has_many :bids, dependent: :destroy
  has_many :project_categories, dependent: :destroy
  has_many :categories, through: :project_categories

  has_one_attached :design_document
  has_one_attached :srs_document

  validates :title, presence: true

  delegate :username, to: :user

  scope :recent_by_user, ->(user) { where(user:).order(created_at: :desc).limit(6) }

  scope :recent, -> { order(created_at: :desc).limit(5) }

  scope :without_awarded_bids, lambda {
    where.not(id: Bid.where(bid_status: :accepted).select(:project_id))
  }

  default_scope { order(:created_at) }

  def self.all_skills
    ['Javascript developer', 'Ruby developer', 'Elixir developer', 'Typescript developer',
     'Python developer', 'Android developer', 'Java developer', 'Graphic designer',
     'HTML/CSS developer', 'System admin', 'Data scientist', 'Technical writer']
  end

  # rubocop:disable Metrics/MethodLength
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

  def visibility_status
    return 'Public' if visibility == 'pub'

    'Private'
  end
end
