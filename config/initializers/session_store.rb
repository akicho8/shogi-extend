# Be sure to restart your server when you modify this file.
if Rails.env.development?
  Rails.application.config.session_store :cookie_store, key: '_shogi_web_session', expire_after: 20.years, domain: ENV["DOMAIN"] || "lvh.me"
else
  Rails.application.config.session_store :cookie_store, key: '_shogi_web_session', expire_after: 20.years
end
