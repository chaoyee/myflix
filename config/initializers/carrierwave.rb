CarrierWave.configure do |config|
  if Rails.env.staging? || Rails.env.production?
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',                    # required
      :aws_access_key_id      => 'AWS_ACCESS_KEY_ID',      # required
      :aws_secret_access_key  => 'AWS_SECRET_ACCESS_KEY',  # required
    }
    config.fog_directory  = 'chstorage'                    # required, 'name_of_directory', AWS S3 bucket name
  else
    config.storage = :file
    config.enable_processing = Rails.env.development?
  end
end