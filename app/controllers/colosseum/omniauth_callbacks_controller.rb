module Colosseum
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
        user ||= User.find_by(email: auth.info.email) # これはセキュリティリスクあり
      end

      # 復元できないときは新規ユーザーを作成する
      unless user
        user = User.create({
            :name       => auth.info.name.presence || auth.info.nickname.presence,
            :email      => auth.info.email || "#{SecureRandom.hex}@localhost",
            :avatar     => {io: image_uri.open, filename: Pathname(image_uri.path).basename, content_type: "image/png"},
            :user_agent => request.user_agent,
          })
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
        redirect_to return_to, notice: message
        return
      end

      # アカウントを作成または復元したのでログイン状態にする
      current_user_set_id(user.id)
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: auth.provider.titleize
      if Rails.env.production? || Rails.env.staging?
      else
        user.lobby_chat_say("ログインしました", :msg_class => "has-text-info")
      end
      sign_in_and_redirect user, event: :authentication
    end

    # 失敗したときの遷移先 (Google+ API を有効にしなかったらこっちにくる)
    # 17:11:32 web.1             |
    # 17:11:32 web.1             | Processing by OmniauthCallbacksController#failure as HTML
    # 17:11:32 web.1             |   Parameters: {"state"=>"ad8ded2ee9913242a12bf0a159805666796f07026a7f2cc1", "code"=>"4/AADISvvSHguBAnvBxf9RBvUaNCCcTAX7ejhpIyUQJ7MBcUUL2ufYBhQ2Se_l64BiJBaDGKqLhKxVXj1pKZTNogA"}
    # 17:11:32 web.1             | Redirected to http://localhost:3000/
    # 17:11:32 web.1             | Completed 302 Found in 1ms (ActiveRecord: 0.0ms)
    def after_omniauth_failure_path_for(resource_name)
      :new_xuser_registration
    end

    # ログインしたあとに移動するパス
    # https://notsleeeping.com/archives/2487
    def after_sign_in_path_for(resource_or_scope)
      return_to = session[:return_to]
      session[:return_to] = nil

      return_to || :root

      # if AppConfig[:colosseum_battle_enable]
      #   [:colosseum, :battles]
      # else
      #   :root
      # end
    end

    private

    def auth
      request.env["omniauth.auth"]
    end

    def current_auth_info
      AuthInfo.find_by(provider: auth.provider, uid: auth.uid)
    end

    def social_media_info
      SocialMediaInfo.fetch(auth.provider)
    end

    def image_uri
      require "open-uri" # for URI#open
      URI(auth.info.image)
    end
  end
end
