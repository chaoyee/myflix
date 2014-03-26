class LargeCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # stroe_dir: uploaded file directory
  # default store_dir: /public/uploads
  #
  # Changing the storage directoty:
  #
  # def store_dir
  #  'public/my/upload/directory'
  # end


  process :resize_to_fill => [665, 375]
end