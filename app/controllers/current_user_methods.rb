module CurrentUserMethods
  extend ActiveSupport::Concern

  included do
    helper_method :admin?
    helper_method :staff?
    helper_method :current_user

    if Rails.env.local?
      before_action do
        if params[:_user_id] || params[:_login_by_key]
          current_user
        end
      end
    end
  end

  def admin?
    current_user && current_user.admin?
  end

  def staff?
    current_user && current_user.staff?
  end

  def editable_record?(record)
    admin? || current_user_is_owner_of?(record)
  end

  def current_user_is_owner_of?(record)
    if current_user
      if record
        if record.respond_to?(:user)
          if record.user
            record.user == current_user
          end
        end
      end
    end
  end

  # いろんなものからログインユーザーを作っている
  # cookies.signed[:user_id] は ActionCable の読み出し用なのでここに入れない方がいいかもしれない
  def current_user
    @current_user ||= yield_self do
      id = nil
      user = nil

      # id ||= User.admin.id
      # Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, params, User.find_by(key: "admin")])

      if Rails.env.local?
        # id ||= User.admin.id
        id ||= params[:_user_id]
        if v = params[:_login_by_key]
          if v = User.find_by(key: v)
            id ||= v.id
          end
        end
      end

      id ||= session[:user_id]
      id ||= cookies.signed[:user_id]
      if id
        user ||= User.find_by(id: id)
      end
      user ||= current_xuser    # from devise

      if user
        if request.format.html? && request.get?
          # rails r "p User.first.cache_key"
          Rails.cache.fetch("#{user.cache_key}/update_tracked_fields!", expires_in: 1.hour) do
            # user.user_agent = request.user_agent.to_s
            user.update_tracked_fields!(request)
            true
          end
        end

        # _user_id パラメータが来ればそれ以降もログインした状態にさせる
        if Rails.env.local?
          if params[:_user_id].present? || params[:_login_by_key].present?
            current_user_set(user)
          end
        end
      end

      if !user
        # ユーザー削除後にそのユーザーと同じでIDでユーザーを作ったとき、
        # セッションに残っているユーザーIDで新しく作ったユーザーにすりかわることができるのを防ぐ
        current_user_clear
      end

      QuickScript::SessionCleaner.new.call(session)

      user
    end
  end

  def current_user_set(user)
    if user.kind_of?(Integer)
      user = User.find_by(id: user)
    end

    if !user.kind_of?(User)
      raise ArgumentError, user.inspect
    end

    session[:user_id] = user.id
    current_user_set_for_action_cable(user)
    sign_in(user, event: :authentication)

    current_user_memoize_variable_clear
  end

  # すでにログインしているユーザーのIDをActionCableで拾えるようにするため
  def current_user_set_for_action_cable(user)
    raise ArgumentError, user.inspect if !user.kind_of?(User)
    cookies.signed[:user_id] = { value: user.id, expires: 1.years.from_now } # for app/channels/application_cable/connection.rb
  end

  # ここで reset_session してはいけない。フォームに記憶した値まで消えてしまう。
  def current_user_clear
    session.delete(:user_id)
    cookies.delete(:user_id)
    sign_out(:xuser)

    current_user_memoize_variable_clear
  end

  def admin_login_unless_logout
    if !current_user
      current_user_set(User.admin)
    end
  end

  private

  def current_user_memoize_variable_clear
    if instance_variable_defined?(:@current_user)
      remove_instance_variable(:@current_user)
    end
  end
end
