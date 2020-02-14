module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      if current_user
        logger.add_tags current_user.name
      end
    end

    def disconnect
      # Any cleanup work needed when the cable connection is cut.
    end

    private

    def find_verified_user
      if session[:user_id]
        user = Colosseum::User.find_by(id: session[:user_id])
      # if cookies.signed[:user_id]
      #   user = Colosseum::User.find_by(id: cookies.signed[:user_id])
        #
        # ここで reject するとログインしていない人が観戦できなくる
        # unless user
        #   reject_unauthorized_connection
        # end
        #
        user
      end
    end
  end
end
