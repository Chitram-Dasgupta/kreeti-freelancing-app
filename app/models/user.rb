class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  has_secure_password

  has_many :projects, dependent: :destroy
  has_many :bids, dependent: :destroy
  has_many :user_categories, dependent: :destroy
  has_many :categories, through: :user_categories

  has_one_attached :profile_picture

  before_save { self.email = email.downcase }

  before_create :confirm_token

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX, message: 'must be a valid email address' },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }, if: :password_changed?, on: :create

  validates :password, length: { minimum: 6 }, allow_blank: true, if: :password_changed?, on: :update

  validates :name, length: { maximum: 255 }

  validates :experience, numericality: { only_integer: true, allow_nil: true, less_than_or_equal_to: 100 }

  enum role: { client: 0, freelancer: 1, admin: 2 }

  def email_activate
    self.email_confirmed = true
    self.confirmation_token = nil
    save
  end

  def confirm_token
    return if confirmation_token.present?

    self.confirmation_token = SecureRandom.urlsafe_base64.to_s
  end

  def password_changed?
    !password.nil? || !password_confirmation.nil?
  end
end
