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

  def display_action(label, path, icon_name, style, http_method)
    link_to(path,
            { class: "btn btn-#{style} mt-2", method: http_method,
              data: (http_method == :delete ? { confirm: 'Are you sure?' } : {}) }) do
      sanitize("#{label} #{icon(icon_name)}")
    end
  end

  def icon(name)
    content_tag(:i, '', class: "bi bi-#{name}")
  end

  def set_project_http_method(icon_name, style)
    if icon_name == 'trash' && style == 'danger'
      :delete
    elsif icon_name == 'chat-dots' && style == 'info'
      :post
    elsif (icon_name == 'check-lg' && style == 'success') ||
          (icon_name == 'x-lg' && style == 'danger')
      :post
    end
  end
end
