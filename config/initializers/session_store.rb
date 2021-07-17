# Be sure to restart your server when you modify this file.
if Rails.env.development?
  # domain: ENV["DOMAIN"] || "0.0.0.0"
  # ↑これを設定すると Nuxt 側からログインできない
  # Rails 側の 0.0.0.0 からのみログインできる
  Rails.application.config.session_store :cookie_store, key: '_shogi_web_session', expire_after: 20.years
else
  Rails.application.config.session_store :cookie_store, key: '_shogi_web_session', expire_after: 20.years
end
