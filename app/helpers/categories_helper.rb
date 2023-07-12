# frozen_string_literal: true

module CategoriesHelper
  def display_category_action(label, path, icon_name, style)
    http_method = (:delete if icon_name == 'trash' && style == 'danger')
    link_to(path,
            { class: "btn btn-#{style} mt-2", method: http_method,
              data: (http_method == :delete ? { confirm: 'Are you sure?' } : {}) }) do
      sanitize("#{label} #{icon(icon_name)}")
    end
  end
end
