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
    auth = request.env["omniauth.auth"]
    # raise auth.to_hash.inspect
    # user = Colosseum::User.find_or_create_from_auth(auth, user: current_user, attributes: {user_agent: request.user_agent})

    logger.info(auth)
    logger.info(auth.to_t)
    logger.info(auth.to_hash)

    social_media_info = SocialMediaInfo.fetch(auth.provider)
    message = nil

    user = current_user

    # ユーザーが特定できていないときは認証情報から復元する
    unless user
      if auth_info = AuthInfo.find_by(provider: auth.provider, uid: auth.uid)
        user ||= auth_info.user
      end
      user ||= find_by(email: auth.info.email)
    end

    # 復元できないときは新規ユーザーを作成する
    unless user
      image = URI(auth.info.image)
      user = create({
          :name       => auth.info.name.presence || auth.info.nickname.presence,
          :email      => auth.info.email || "#{SecureRandom.hex}@localhost",
          :password   => Devise.friendly_token(32),
          :avatar     => {io: image.open, filename: Pathname(image.path).basename, content_type: "image/png"},
          :user_agent => request.user_agent,
        })
    end

    # ユーザーに認証情報が含まれていなければ追加する
    if user.valid?
      unless user.auth_infos.find_by(provider: auth.provider, uid: auth.uid)
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
      # current_user_set_id(nil)
      # session["devise.google_data"] = auth.except(:extra)
      redirect_to :new_xuser_registration, alert: user.errors.full_messages.join("\n")
      return
    end

    if current_user
      message = "#{social_media_info.name}アカウントと連携しました"
      return_to = session[:return_to] || :new_xuser_registration
      session[:return_to] = nil
      redirect_to return_to, notice: message
      return
    end

    current_user_set_id(user.id)
    flash[:tost_notice] = I18n.t "devise.omniauth_callbacks.success", kind: auth.provider.titleize
    sign_in_and_redirect user, event: :authentication
  end

  # 失敗したときの遷移先 (Google+ API を有効にしなかったらこっちにくる)
  # 17:11:32 web.1             |
  # 17:11:32 web.1             | Processing by OmniauthCallbacksController#failure as HTML
  # 17:11:32 web.1             |   Parameters: {"state"=>"ad8ded2ee9913242a12bf0a159805666796f07026a7f2cc1", "code"=>"4/AADISvvSHguBAnvBxf9RBvUaNCCcTAX7ejhpIyUQJ7MBcUUL2ufYBhQ2Se_l64BiJBaDGKqLhKxVXj1pKZTNogA"}
  # 17:11:32 web.1             | Redirected to http://localhost:3000/
  # 17:11:32 web.1             | Completed 302 Found in 1ms (ActiveRecord: 0.0ms)
  def after_omniauth_failure_path_for(resource_name)
    :root
  end
end
