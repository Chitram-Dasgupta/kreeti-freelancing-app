# frozen_string_literal: true

module Editable
  extend ActiveSupport::Concern

  class_methods do
    def editable_by(user)
      if user.admin?
        all
      else
        where(user:)
      end
    end
  end
end
