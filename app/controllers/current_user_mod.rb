module CurrentUserMod
  extend ActiveSupport::Concern

  included do
    helper_method :js_global
    helper_method :sysop?
    helper_method :editable_record?
    helper_method :current_user
  end

  def js_global
    @js_global ||= {
      :current_user => current_user && ams_sr(current_user, serializer: Colosseum::BasicUserSerializer),
      :talk_path    => talk_path,
    }
  end

  let :sysop? do
    current_user && current_user.sysop?
  end

  def editable_record?(record)
    sysop? || current_user_is_owner_of?(record)
  end

  def current_user_is_owner_of?(record)
    if current_user
      if record
        if record.respond_to?(:owner_user)
          if record.owner_user
            record.owner_user == current_user
          end
        end
      end
    end
  end

  let :current_user do
    id = nil
    id ||= session[:user_id]
    id ||= cookies.signed[:user_id]

    if id
      user = nil
      user ||= Colosseum::User.find_by(id: id)
      user ||= current_xuser

      # if Rails.env.test?
      #   if params[:__create_user_name__]
      #     user ||= Colosseum::User.create!(name: params[:__create_user_name__], user_agent: request.user_agent)
      #     user.lobby_in_handle
      #     cookies.signed[:user_id] = {value: user.id, expires: 1.years.from_now}
      #   end
      # end

      # if user
      #   cookies.signed[:user_id] = {value: user.id, expires: 1.years.from_now}
      # end
    end
  end

  def current_user_set(user)
    unless user.kind_of?(Integer) || user.kind_of?(Colosseum::User)
      raise ArgumentError, user.inspect
    end

    if user.kind_of?(Integer)
      user = Colosseum::User.find_by(id: user)
    end

    unless user.kind_of?(Colosseum::User)
      raise ArgumentError, user.inspect
    end

    session[:user_id] = user.id
    cookies.signed[:user_id] = { value: user.id, expires: 1.years.from_now } # for app/channels/application_cable/connection.rb
    sign_in(user, event: :authentication)

    current_user_memoize_variable_clear
  end

  def current_user_clear
    if current_user
      current_user.lobby_out_handle
    end

    session.delete(:user_id)
    cookies.delete(:user_id)
    sign_out(:xuser)

    current_user_memoize_variable_clear
  end

  def sysop_login_unless_logout
    unless current_user
      current_user_set(Colosseum::User.sysop)
    end
  end

  private

  def current_user_memoize_variable_clear
    if instance_variable_defined?(:@current_user)
      remove_instance_variable(:@current_user)
    end
  end
end
