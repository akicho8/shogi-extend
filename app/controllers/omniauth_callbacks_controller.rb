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
    user = Fanta::User.find_or_create_from_auth(auth, user_agent: request.user_agent)

    if user.invalid?
      current_user_set_id(nil)
      # session["devise.google_data"] = auth.except(:extra)
      redirect_to :new_xuser_registration, alert: user.errors.full_messages.join("\n")
      return
    end

    current_user_set_id(user.id)
    flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: auth.provider.titleize
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
