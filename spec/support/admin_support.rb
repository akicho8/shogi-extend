module AdminSupport
  extend ActiveSupport::Concern

  # 管理画面にログインした状態にする
  def http_auth_login
    user_name = SecureRandom.hex
    password = Rails.application.credentials[:admin_password]
    encode_credentials = ActionController::HttpAuthentication::Basic.encode_credentials(user_name, password)
    request.env["HTTP_AUTHORIZATION"] = encode_credentials
  end
end
