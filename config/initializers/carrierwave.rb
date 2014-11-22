CarrierWave.configure do |config|

  if Rails.env.production?
    config.storage :fog

    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['AWS_ACCESS_KEY'],
      :aws_secret_access_key  => ENV['AWS_SECRET'],
      :region                 => 'eu-central-1'
    }
    config.fog_directory  = 'janusz3'
    config.fog_public     = true
    config.fog_attributes = {'Cache-Control'=>"max-age=#{365.day.to_i}"}
  else
    config.storage :file
  end
end
