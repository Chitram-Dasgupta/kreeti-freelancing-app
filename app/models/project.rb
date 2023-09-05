# frozen_string_literal: true

class Project < ApplicationRecord
  include Searchable
  include Editable
  include FileValidatable

  def as_indexed_json(_options = {})
    as_json(
      include: { categories: { only: :name } }
    )
  end

  settings index: { number_of_shards: 1 } do
    mapping dynamic: 'false' do
      indexes :categories, type: :nested do
        indexes :name
      end
    end
  end

  paginates_per 12

  belongs_to :user

  has_many :bids, dependent: :destroy
  has_many :project_categories, dependent: :destroy
  has_many :categories, through: :project_categories
  has_many :notifications, dependent: :destroy

  has_one_attached :design_document
  has_one_attached :srs_document

  validates :categories, presence: true
  validates :title, presence: true, length: { maximum: 64 }
  validates :description, length: { maximum: 1024 }
  validate :check_file_type_and_size

  delegate :username, to: :user

  scope :all_projects, -> { all }

  default_scope { order(created_at: :desc) }

  def bid_awarded?
    bids.exists?(bid_status: 'accepted')
  end

  def accepted_bid_freelancer
    bids.find_by(bid_status: :accepted)&.user
  end

  def self.search_projects(category_name)
    __elasticsearch__.search(search_definition(category_name))
  end

  private

  def check_file_type_and_size
    check_file_type_and_size_for(:design_document, 25)
    check_file_type_and_size_for(:srs_document, 25)
  end
end
