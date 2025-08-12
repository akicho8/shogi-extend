# |----------+-----------------+---------------------------+--------------------------+-------------|
# | Provider | nickname        | name                      | email                    | description |
# |----------+-----------------+---------------------------+--------------------------+-------------|
# | Twitter  | "sgkinakomochi" | "きなこもち"              | ""                       | "..."       |
# | Google   | nil             | "Akira Ikeda"             | "pinpon.ikeda@gmail.com" | nil         |
# |----------+-----------------+---------------------------+--------------------------+-------------|
#
# リダイレクト先
# |----------+--------------------------------------+-------------------------|
# | 場所     | URL                                  | method                  |
# |----------+--------------------------------------+-------------------------|
# | ログイン | http://localhost:3000/xusers/sign_in | :new_xuser_session      |
# | 登録     | http://localhost:3000/xusers/sign_up | :new_xuser_registration |
# |----------+--------------------------------------+-------------------------|

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
    AppLog.info(subject: "認証", body: "#{user_name} #{auth.info.email} (#{auth.provider}) #{auth.info.image}")

    @user = current_user

    # ユーザーが特定できていないときは認証情報から復元する
    if !@user
      if current_auth_info
        @user ||= current_auth_info.user
      end
    end

    # 復元できないときは新規ユーザーを作成する
    # Google の場合なぜか auth.info.name にメールアドレスが入っている
    if @user
    else
      user_create
      avter_process
    end
    email_process
    auth_infos_append

    if performed?
      return
    end

    if @user.invalid?
      AppLog.error(subject: "ユーザー作成失敗", body: [@user.errors.full_messages, @user.attributes, auth].as_json)
      redirect_to :new_xuser_session, alert: @user.errors.full_messages.join("\n")
      return
    end

    # 何でログインしたかを最低限残す
    session[:provider_remember] = { user_name: @user.name, provider: social_media_info.key.to_s } # 参照するときキーは文字列になるので注意

    # 元々ユーザーが存在していればアカウント連携しようとしたことになる
    if current_user
      message = "#{social_media_info.name} アカウントと連携しました"
      return_to = session[:return_to] || :new_xuser_session
      session[:return_to] = nil
      redirect_to return_to, notice: message
      return
    end

    # アカウントを作成または復元したのでログイン状態にする
    current_user_set(@user)

    if false
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: auth.provider.titleize
      sign_in_and_redirect @user, event: :authentication # or redirect_to after_sign_in_path_for(@user)
    else
      redirect_to_user_with_message "#{social_media_info.name} でログインしました。"
    end
  end

  # 失敗したときの遷移先 (Google+ API を有効にしなかったらこっちにくる)
  def after_omniauth_failure_path_for(resource_name)
    :new_xuser_session
  end

  private

  def user_create
    @user = User.create do |e|
      e.email         = auth.info.email # Twitterの場合は空文字列 (TODO: 空なのは認証していないってことなのでは？)
      e.confirmed_at  = Time.current    # メール認証したことにする
      e.name          = user_name
      e.name_input_at = Time.current
      # e.user_agent    = request.user_agent
    end
  end

  def avter_process
    begin
      if @user && @user.valid?
        if auth.info.image
          filename = Pathname(image_uri.path).basename.to_s
          io = image_uri.open
          @user.avatar = { io: io, filename: filename, content_type: "image/png" }
          @user.save
        else
          AppLog.info(subject: "auth.info.image is blank")
        end
      end
    rescue => error
      AppLog.error(error)
    end
  end

  # ユーザーのメールアドレスが空だったり初期値なら設定する
  def email_process
    if @user.valid?
      if @user.email_invalid?
        @user.email = auth.info.email
        @user.skip_reconfirmation!
        @user.save!
      end
    end
  end

  def auth_infos_append
    # ユーザーに認証情報が含まれていなければ追加する
    if @user.valid?
      if !@user.auth_infos.find_by(provider: auth.provider)
        auth_info = @user.auth_infos.create(auth: auth)
        if auth_info.invalid?
          return_to = session[:return_to] || :new_xuser_session
          session[:return_to] = nil
          if false
            redirect_to return_to, alert: auth_info.errors.full_messages.join("\n")
            return
          else
            redirect_to_url_with_message return_to, auth_info.errors.full_messages.join("\n")
            return
          end
        end
      end
    end
  end

  def auth
    request.env["omniauth.auth"]
  end

  def user_name
    auth.info.name.presence
  end

  def current_auth_info
    @current_auth_info ||= AuthInfo.find_by(provider: auth.provider, uid: auth.uid)
  end

  def social_media_info
    @social_media_info ||= SocialMediaInfo.fetch(auth.provider)
  end

  def image_uri
    URI(auth.info.image)
  end

  def redirect_to_url_with_message(return_to, message)
    query = { return_to: return_to, message: message }
    url = UrlProxy.url_for(path: "/lab/chore/message", query: query)
    redirect_to url, allow_other_host: true
  end

  def redirect_to_user_with_message(message)
    return_to = after_sign_in_path_for(@user) # device のメソッド
    if return_to.kind_of?(Symbol)
      return_to = send("#{return_to}_url") # :root を root_url の結果に変換する。これをしないとフロント側で href="root" となってしまう。
    end
    redirect_to_url_with_message return_to, message
  end
end
