# frozen_string_literal: true

module ProjectsHelper
  def all_skills
    ['Javascript developer', 'Ruby developer', 'Elixir developer', 'Typescript developer',
     'Python developer', 'Android developer', 'Java developer', 'Graphic designer',
     'HTML/CSS developer', 'System admin', 'Data scientist', 'Technical writer']
  end

  def display_badges(collection, attribute = nil)
    if collection.empty?
      'Not available'
    else
      badges = collection.map do |item|
        content = attribute ? item.send(attribute) : item
        content_tag(:span, content, class: "badge #{cycle('bg-primary', 'bg-secondary', 'bg-success',
                                                          'bg-danger', 'bg-warning', 'bg-info')}")
      end
      safe_join(badges, ' ')
    end
  end

  def display_document(label, document)
    if document.attached?
      content_tag(:p) do
        concat label
        concat ' '
        concat link_to(document.filename, url_for(document), class: 'btn btn-primary mt-2')
      end
    else
      content_tag(:p, "No #{label.downcase} attached.")
    end
  end

  def display_project_action(label, path, icon_name, style)
    http_method = set_project_http_method(icon_name, style)
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
    end
  end

  def user_has_bid?(project, user)
    project.bids.exists?(user_id: user.id)
  end
end
