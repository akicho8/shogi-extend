# Be sure to restart your server when you modify this file.

options = {
  :key          => "_shogi_web_session",
  :expire_after => 20.years,
}

if Rails.env.development?
  options[:domain] = ENV["DOMAIN"] || "localhost"
end

Rails.application.config.session_store(:cookie_store, options)
