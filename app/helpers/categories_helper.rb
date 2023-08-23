# frozen_string_literal: true

module CategoriesHelper
  def display_category_action(label, path, icon_name, style)
    http_method = set_http_method(icon_name, style)
    display_action(label, path, icon_name, style, http_method)
  end
end
