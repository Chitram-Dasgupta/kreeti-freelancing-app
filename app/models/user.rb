class User < ApplicationRecord
  include Searchable

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_secure_password

  has_many :projects, dependent: :destroy
  has_many :bids, dependent: :destroy
  has_many :user_categories, dependent: :destroy
  has_many :categories, through: :user_categories
  has_many :notifications, foreign_key: :recipient_id
  has_many :user_rooms, foreign_key: :user1_id
  has_many :user_rooms, foreign_key: :user2_id
  has_many :rooms, through: :user_rooms
  has_many :messages, dependent: :destroy

  has_one_attached :profile_picture

  before_save { self.email = email.downcase }

  before_create :confirm_token

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX, message: 'must be a valid email address' },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }, if: :password_changed?, on: :create

  validates :password, length: { minimum: 6 }, allow_blank: true, if: :password_changed?, on: :update

  validates :username, presence: true, uniqueness: true, length: { maximum: 255 }

  validates :experience, numericality: { only_integer: true, allow_nil: true, less_than_or_equal_to: 100 }

  validates :role, presence: true

  enum role: { client: 0, freelancer: 1, admin: 2 }
  enum visibility: { pub: 0, priv: 1 }

  def email_activate
    if confirmation_token_created_at < 30.minutes.ago
      errors.add(:confirmation_token, 'expired')
    else
      self.email_confirmed = true
      self.confirmation_token = nil
      self.confirmation_token_created_at = nil
      save
    end
  end

  def confirm_token
    return if confirmation_token.present?

    self.confirmation_token = SecureRandom.urlsafe_base64.to_s
    self.confirmation_token_created_at = Time.current
  end

  def password_changed?
    !password.nil? || !password_confirmation.nil?
  end

  def self.search_freelancer(category_name)
    search_definition = {
      query: {
        bool: {
          filter: [
            { term: { role: 'freelancer' } }
          ],
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
                'visibility': 'pub'
              }
            }
          ]
        }
      }
    }

    __elasticsearch__.search(search_definition)
  end

  def visibility_status
    return 'Public' if visibility == 'pub'

    'Private'
  end
end
