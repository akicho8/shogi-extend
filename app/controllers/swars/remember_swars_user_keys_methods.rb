module Swars
  concern :RememberSwarsUserKeysMethods do
    included do
      cattr_accessor(:remember_swars_user_keys_max) { 20 }
    end

    private

    def remember_swars_user_keys_update
      if remember_swars_user_keys_max
        if user = current_swars_user
          list = [
            user.key,
            # *query_info.lookup(:"vs"),
            *session[:remember_swars_user_keys],
          ]
          session[:remember_swars_user_keys] = remember_swars_user_keys_normalize(list)
        end
      end
    end

    def remember_swars_user_keys
      v = Array(session[:remember_swars_user_keys])
      if Rails.env.development? || Rails.env.test?
        v += %w(devuser1 devuser2 補完される文字列の全体)
        v = remember_swars_user_keys_normalize(v)
      end
      v
    end

    def remember_swars_user_keys_normalize(list)
      list.uniq.take(remember_swars_user_keys_max)
    end
  end
end
