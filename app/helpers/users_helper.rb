# frozen_string_literal: true

module UsersHelper
  def all_qualifications
    ['No formal education', 'High School', 'Diploma', 'Bachelor of Science', 'Bachelor of Arts',
     'Bachelor of Commerce', 'Bachelor of Technology', 'Master of Science', 'Master of Arts',
     'Master of Commerce', 'Master of Technology', 'PhD', 'Post Doctorate']
  end

  def display_user_action(label, path, icon_name, style)
    http_method = set_http_method(icon_name, style)
    display_action(label, path, icon_name, style, http_method)
  end

  def visibility_status(user)
    user.pub? ? 'Public' : 'Private'
  end
end
