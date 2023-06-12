class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  has_secure_password

  before_save { self.email = email.downcase }

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX, message: 'must be a valid email address' },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }
end
