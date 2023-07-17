# frozen_string_literal: true

module UsersHelper
  def display_user_action(label, path, icon_name, style)
    http_method = set_http_method(icon_name, style)
    link_to(path,
            { class: "btn btn-#{style} mt-2", method: http_method,
              data: (http_method == :delete ? { confirm: 'Are you sure?' } : {}) }) do
      sanitize("#{label} #{icon(icon_name)}")
    end
  end

  def set_http_method(icon_name, style)
    if icon_name == 'trash' && style == 'danger'
      :delete
    elsif (icon_name == 'check-lg' && style == 'success') ||
          (icon_name == 'x-lg' && style == 'danger')
      :post
    end
  end

  def icon(name)
    content_tag(:i, '', class: "bi bi-#{name}")
  end

  def visibility_status(user)
    return 'Public' if user.visibility == 'pub'

    'Private'
  end

  def all_qualifications
    ['No formal education', 'High School', 'Diploma', 'Bachelor of Science', 'Bachelor of Arts',
     'Bachelor of Commerce', 'Bachelor of Technology', 'Master of Science', 'Master of Arts',
     'Master of Commerce', 'Master of Technology', 'PhD', 'Post Doctorate']
  end
end
