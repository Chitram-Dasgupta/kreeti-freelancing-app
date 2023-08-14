# frozen_string_literal: true

module Editable
  extend ActiveSupport::Concern

  included do
    scope :editable_by, ->(user) { where(user:).or(where(user: User.where(role: 'admin'))) }
  end
end
