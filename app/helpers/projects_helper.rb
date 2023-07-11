# frozen_string_literal: true

module ProjectsHelper
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

  def display_badges(collection, attribute = nil)
    if collection.empty?
      'Not available'
    else
      badges = collection.map do |item|
        content = attribute ? item.send(attribute) : item
        content_tag(:span, content,
                    class: "badge #{cycle('bg-primary', 'bg-secondary', 'bg-success', 'bg-danger', 'bg-warning', 'bg-info')}")
      end
      safe_join(badges, ' ')
    end
  end

  def display_project_action(label, path, icon_name, style, options = {})
    link_to(path, { class: "btn btn-#{style} mt-2" }.merge(options)) do
      sanitize("#{label} #{icon(icon_name)}")
    end
  end
end
