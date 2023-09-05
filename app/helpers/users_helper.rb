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

  def common_profile_details_array(user)
    [['Username', user.username], ['Email', user.email], ['Industry', user.industry],
     ['Visibility', visibility_status(user)]]
  end

  def shared_form_fields_array
    [[:username, 'text'], [:email, 'email'], [:password, 'password'], [:password_confirmation, 'password'],
     [:industry, 'text'], [:profile_picture, 'file']]
  end

  def editable_shared_form_fields_array
    [[:username, 'text'], [:profile_picture, 'file'], [:industry, 'text']]
  end

  def user_role_options
    [%w[Client client], %w[Freelancer freelancer]]
  end

  def freelancer_visibility_options
    [%w[pub Public], %w[priv Private]]
  end
end
