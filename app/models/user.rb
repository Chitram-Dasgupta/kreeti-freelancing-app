# frozen_string_literal: true

class User < ApplicationRecord
  include Searchable

  def as_indexed_json(_options = {})
    as_json(
      only: %i[role visibility],
      include: { categories: { only: :name } }
    )
  end

  settings index: { number_of_shards: 1 } do
    mapping dynamic: 'false' do
      indexes :visibility
      indexes :role
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
  has_many :user1_rooms, foreign_key: :user1_id, class_name: 'UserRoom', dependent: :destroy, inverse_of: :user1
  has_many :user2_rooms, foreign_key: :user2_id, class_name: 'UserRoom', dependent: :destroy, inverse_of: :user2
  has_many :rooms, through: :user_rooms

  has_one_attached :profile_picture

  validates :categories, presence: true, if: -> { freelancer? }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX, message: 'must be a valid email address' },
                    uniqueness: { case_sensitive: false }
  validates :experience,
            numericality: { only_integer: true, allow_nil: true, less_than_or_equal_to: 100 }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :role, presence: true, inclusion: { in: %w[freelancer client] }
  validates :username, presence: true, uniqueness: true, length: { maximum: 255 }

  scope :approved_users, -> { where(status: 'approved') }
  scope :pending_users, -> { where(status: 'pending') }
  scope :visible_to, ->(user) { user&.role == 'admin' ? all : where.not(visibility: 'priv').or(where(id: user&.id)) }

  default_scope { order(created_at: :desc) }

  def confirm_token
    return if confirmation_token.present?

    self.confirmation_token = SecureRandom.urlsafe_base64.to_s
    self.confirmation_token_created_at = Time.current
  end

  def email_activate
    return errors.add(:base, 'Account not approved yet') unless status == 'approved'

    if confirmation_token_created_at < 60.minutes.ago
      errors.add(:confirmation_token, 'expired')
    else
      self.email_confirmed = true
      self.confirmation_token = nil
      self.confirmation_token_created_at = nil
      save
    end
  end

  # rubocop:disable Metrics/MethodLength
  def self.search_freelancer(category_name)
    search_definition = {
      size: 1000,
      query: {
        bool: {
          filter: [
            { term: { role: 'freelancer' } }
          ],
          must: [
            {
              nested: {
                path: 'categories',
                query: if category_name.present?
                         {
                           match_phrase: {
                             'categories.name': category_name
                           }
                         }
                       else
                         {
                           match_all: {}
                         }
                       end
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
end
