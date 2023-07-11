# frozen_string_literal: true

module RoomsHelper
  def display_room_action(label, path, icon_name, style, options = {})
    link_to(path, { class: "btn btn-#{style} mr-auto" }.merge(options)) do
      sanitize("#{label} #{icon(icon_name)}")
    end
  end
end
