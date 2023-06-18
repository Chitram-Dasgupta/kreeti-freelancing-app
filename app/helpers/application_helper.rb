module ApplicationHelper
  def flash_class(level)
    case level
    when 'error'
      'alert-danger'
    when 'notice'
      'alert-info'
    when 'success'
      'alert-success'
    else
      'alert-info'
    end
  end
end
