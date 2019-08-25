Rails.application.configure do
  config.rack_dev_mark.enable = !Rails.env.production?
end
