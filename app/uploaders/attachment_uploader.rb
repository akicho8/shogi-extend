class AttachmentUploader < CarrierWave::Uploader::Base
  def store_dir
    ["system", "attachment", Rails.env, model.class.name.underscore.pluralize, mounted_as, model.id].join("/")
  end
end
