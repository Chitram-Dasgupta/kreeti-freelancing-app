class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  has_secure_password

  before_save { self.email = email.downcase }

  before_create :confirm_token

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX, message: 'must be a valid email address' },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }

  def email_activate
    self.email_confirmed = true
    self.confirmation_token = nil
    save!(:validate => false)
  end

  # private

def confirm_token
      if self.confirmation_token.blank?
          self.confirmation_token = SecureRandom.urlsafe_base64.to_s
      end
    end
end
