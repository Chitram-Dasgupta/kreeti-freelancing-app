# frozen_string_literal: true

class UserCategory < ApplicationRecord
  belongs_to :category
  belongs_to :user
end
