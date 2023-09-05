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

  def set_http_method(icon_name, style)
    http_methods = {
      %w[trash danger] => :delete,
      %w[chat-dots info] => :post,
      %w[check-lg success] => :post,
      %w[x-lg danger] => :post
    }

    http_methods[[icon_name, style]]
  end

  def cycle_bg_colors_badge(content)
    content_tag(:span, content, class: "badge #{cycle('bg-primary', 'bg-secondary', 'bg-success',
                                                      'bg-danger', 'bg-warning', 'bg-info')}")
  end
end
