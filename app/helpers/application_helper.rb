# frozen_string_literal: true

module ApplicationHelper
  def flash_class(level)
    case level
    when 'error'
      'alert-danger'
    when 'success'
      'alert-success'
    else
      'alert-info'
    end
  end
end
