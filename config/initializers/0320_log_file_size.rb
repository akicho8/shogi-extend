if Rails.env.local?
  Rails.application.config.log_file_size = 10.megabytes
end
