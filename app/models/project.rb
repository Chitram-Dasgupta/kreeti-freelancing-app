class Project < ApplicationRecord
  belongs_to :user

  has_many :bids, dependent: :destroy

  has_one_attached :design_document
  has_one_attached :srs_document

  validates :title, presence: true

  enum visibility: %i[pub priv]

  scope :recent_by_user, ->(user) { where(user: user).order(created_at: :desc).limit(5) }

  scope :recent, -> { order(created_at: :desc).limit(5) }

  def visibility_status
    if self.visibility == 'pub'
      'Public'
    else
      'Private'
    end
  end
end
