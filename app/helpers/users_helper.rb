# frozen_string_literal: true

module UsersHelper
  def display_user_action(label, path, icon_name, style, options = {})
    link_to(path, { class: "btn btn-#{style} mt-2" }.merge(options)) do
      sanitize("#{label} #{icon(icon_name)}")
    end
  end
end
