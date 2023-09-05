# frozen_string_literal: true

module FileValidatable
  extend ActiveSupport::Concern

  private

  def check_file_type_and_size_for(attribute, file_size, profile_pic: false)
    file = send(attribute)
    return unless file.attached?

    check_file_type(attribute, file, profile_pic) if file.attached?
    check_file_size(attribute, file, file_size) if file.attached?
  end

  def check_file_type(attribute, file, profile_pic)
    return if profile_pic && file.content_type.in?(%w[image/jpeg image/png])
    return if !profile_pic && file.content_type.in?(%w[application/pdf])

    file_type = profile_pic ? 'JPEG or PNG' : 'PDF'
    errors.add(attribute, "must be a #{file_type} file")
  end

  def check_file_size(attribute, file, file_size)
    return unless file.blob.byte_size > file_size.megabytes

    errors.add(attribute, "size must be less than #{file_size}MB")
  end
end
