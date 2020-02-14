module Swars
  module RememberSwarsUserKeysMod
    extend ActiveSupport::Concern

    included do
      cattr_accessor(:remember_swars_user_keys_max) { 10 }

      helper_method :remember_swars_user_keys
    end

    private

    def remember_swars_user_keys_update
      if current_swars_user
        if remember_swars_user_keys_max
          if v = cookies.permanent.signed[:remember_swars_user_keys]
            session[:remember_swars_user_keys] = v
            cookies.delete(:remember_swars_user_keys)
          end
          session[:remember_swars_user_keys] = remember_swars_user_keys_normalize([current_swars_user.user_key, *session[:remember_swars_user_keys]])
        end
      end
    end

    def remember_swars_user_keys
      v = Array(session[:remember_swars_user_keys])
      if Rails.env.development?
        v += %w(devuser1 foo bar baz 日本語 あいうえお)
      end
      v
    end

    def remember_swars_user_keys_normalize(list)
      list.uniq.take(remember_swars_user_keys_max)
    end
  end
end
