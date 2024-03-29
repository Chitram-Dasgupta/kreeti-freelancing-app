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
        cycle_bg_colors_badge(content)
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
    http_method = set_http_method(icon_name, style)
    display_action(label, path, icon_name, style, http_method)
  end

  def user_has_bid?(project, user)
    project.bids.exists?(user_id: user.id)
  end

  def awarded_freelancer(project)
    project.bids.accepted.first&.user
  end
end
