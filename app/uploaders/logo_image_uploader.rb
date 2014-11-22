class LogoImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # process :resize_to_fit => [800, 800]

  version :thumb do
    process :resize_to_fill => [360, 200]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
