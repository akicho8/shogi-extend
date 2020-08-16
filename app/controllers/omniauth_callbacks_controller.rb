require "open-uri" # for URI#open

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google
    auth_shared_process
  end

  def twitter
    auth_shared_process
  end

  def github
    auth_shared_process
  end

  def auth_shared_process
    logger.info(auth.to_hash)

    user = current_user

    # ユーザーが特定できていないときは認証情報から復元する
    unless user
      if current_auth_info
        restoration = true
        user ||= current_auth_info.user
      end

      # メールアドレス一致でも復元する場合
      # これはやりすぎ
      # 他人が自分のメアドに設定しているとき他人が自分になれてしまう
      if false
        user ||= User.find_by(email: auth.info.email)
      end
    end

    # 復元できないときは新規ユーザーを作成する
    # Google の場合なぜか auth.info.name にメールアドレスが入っている
    unless user
      SlackAgent.message_send(key: "omniauth", body: auth.as_json) # デバッグ用

      begin
        user = User.create do |e|
          e.email      = auth.info.email
          e.user_agent = request.user_agent

          # Googleの場合 auth.info.name にメールアドレスを入れてきやがるためおかしなことになる
          # しかも名前がどこにもない。だから @ の前を仮の名前をとして入れて name_input_at は nil のままにしておく
          if email_format?
            e.name = name_extract_from_email
          else
            e.name = user_name
            e.name_input_at = Time.current
          end
        end
      rescue => error
        SlackAgent.message_send(key: "omniauth error", body: error.inspect)
      end

      begin
        if user && user.valid?
          if auth.info.image
            user.avatar = {io: image_uri.open, filename: Pathname(image_uri.path).basename, content_type: "image/png"}
            user.save
          end
        end
      rescue => error
        SlackAgent.message_send(key: "omniauth error", body: error.inspect)
      end
    end

    # ユーザーに認証情報が含まれていなければ追加する
    if user.valid?
      unless user.auth_infos.find_by(provider: auth.provider)
        auth_info = user.auth_infos.create(auth: auth)
        if auth_info.invalid?
          return_to = session[:return_to] || :new_xuser_registration
          session[:return_to] = nil
          redirect_to return_to, alert: auth_info.errors.full_messages.join("\n")
          return
        end
      end
    end

    if user.invalid?
      redirect_to :new_xuser_registration, alert: user.errors.full_messages.join("\n")
      return
    end

    # 何でログインしたかを最低限残す
    session[:provider_remember] = { user_name: user.name, provider: social_media_info.key.to_s } # 参照するときキーは文字列になるので注意

    # 元々ユーザーが存在していればアカウント連携しようとしたことになる
    if current_user
      message = "#{social_media_info.name} アカウントと連携しました"
      return_to = session[:return_to] || :new_xuser_registration
      session[:return_to] = nil
      redirect_to return_to, toast_notice: message
      return
    end

    # アカウントを作成または復元したのでログイン状態にする
    current_user_set(user)
    flash[:toast_info] = I18n.t "devise.omniauth_callbacks.success", kind: auth.provider.titleize
    sign_in_and_redirect user, event: :authentication # or redirect_to after_sign_in_path_for(user)
  end

  # 失敗したときの遷移先 (Google+ API を有効にしなかったらこっちにくる)
  # |
  # | Processing by OmniauthCallbacksController#failure as HTML
  # |   Parameters: {"state"=>"ad8d...", "code"=>"4/AAD..."}
  # | Redirected to http://localhost:3000/
  # | Completed 302 Found in 1ms (ActiveRecord: 0.0ms)
  # |
  def after_omniauth_failure_path_for(resource_name)
    :new_xuser_registration
  end

  private

  def auth
    request.env["omniauth.auth"]
  end

  def user_name
    auth.info.name.presence || auth.info.nickname.presence
  end

  def current_auth_info
    AuthInfo.find_by(provider: auth.provider, uid: auth.uid)
  end

  def social_media_info
    SocialMediaInfo.fetch(auth.provider)
  end

  def image_uri
    URI(auth.info.image)
  end

  # メールアドレスなら@の前を取得
  #  "alice@localhost" --> "alice"
  def name_extract_from_email
    Mail::Address.new(user_name).local
  end

  # str はメールアドレスか？
  def email_format?
    a = Mail::Address.new(user_name)
    if a.domain
      a.local
    end
  rescue Mail::Field::IncompleteParseError
    false
  end
end
