# frozen_string_literal: true

class User < ApplicationRecord
  include Searchable
  include FileValidatable

  def as_indexed_json(_options = {})
    as_json(
      only: %i[role visibility email_confirmed],
      include: { categories: { only: :name } }
    )
  end

  settings index: { number_of_shards: 1 } do
    mapping dynamic: 'false' do
      indexes :visibility
      indexes :role
      indexes :email_confirmed
      indexes :categories, type: :nested do
        indexes :name
      end
    end
  end

  paginates_per 12

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_secure_password

  before_save { self.email = email.downcase }

  before_create :confirm_token

  enum role: { client: 0, freelancer: 1, admin: 2 }
  enum status: { pending: 0, approved: 1, rejected: 2 }
  enum visibility: { pub: 0, priv: 1 }

  has_many :bids, dependent: :nullify
  has_many :user_categories, dependent: :destroy
  has_many :categories, through: :user_categories
  has_many :projects, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy, inverse_of: :recipient
  has_many :sender_rooms, foreign_key: :sender_id, class_name: 'UserRoom', dependent: :destroy, inverse_of: :sender
  has_many :receiver_rooms, foreign_key: :receiver_id, class_name: 'UserRoom', dependent: :destroy,
                            inverse_of: :receiver
  has_many :rooms, through: :user_rooms

  has_one_attached :profile_picture

  validates :categories, presence: true, if: -> { freelancer? }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX, message: 'must be a valid email address' },
                    uniqueness: { case_sensitive: false }
  validates :experience,
            numericality: { only_integer: true, allow_nil: true, less_than_or_equal_to: 100 }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :role, presence: true, inclusion: { in: %w[freelancer client] }, unless: :admin?
  validates :username, presence: true, uniqueness: true, length: { maximum: 255 }
  validate :check_file_type_and_size

  scope :approved_users, -> { where(status: 'approved') }
  scope :pending_users, -> { where(status: 'pending') }
  scope :visible_to, ->(user) { user&.role == 'admin' ? all : where.not(visibility: 'priv').or(where(id: user&.id)) }
  scope :approved_non_admins, -> { approved_users.where.not(role: 'admin') }
  scope :rejected_email, ->(email) { where(email:, status: 'rejected') }

  default_scope { order(created_at: :desc) }

  def confirm_token
    return if confirmation_token.present?

    self.confirmation_token = SecureRandom.urlsafe_base64.to_s
    self.confirmation_token_created_at = Time.current
  end

  def email_activate
    return errors.add(:base, 'Account not approved yet') unless approved?

    if confirmation_token_created_at < 60.minutes.ago
      errors.add(:confirmation_token, 'expired')
    else
      self.email_confirmed = true
      self.confirmation_token = nil
      self.confirmation_token_created_at = nil
      save
    end
  end

  def self.search_freelancer(category_name)
    filter = [
      { term: { role: 'freelancer' } },
      { term: { email_confirmed: true } },
      { term: { visibility: 'pub' } }
    ]
    __elasticsearch__.search(search_definition(category_name, filter))
  end

  def approve
    update(status: 'approved')
    UserMailer.account_activation(self).deliver_later
  end

  def reject
    update(status: 'rejected', confirmation_token: nil)
  end

  private

  def check_file_type_and_size
    check_file_type_and_size_for(:profile_picture, 5, profile_pic: true)
  end
end
