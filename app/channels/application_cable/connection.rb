module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      if current_user
        logger.add_tags [current_user.id, current_user.name].join(":")
        current_user.actb_lobby_messages.create!(body: "*Connection#connect")
      end
    end

    def disconnect
      # Any cleanup work needed when the cable connection is cut.
      Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__])
      if current_user
        current_user.actb_lobby_messages.create!(body: "*Connection#disconnect")
      end
    end

    private

    def find_verified_user
      # current_user_set で cookies に入れているので取れる
      User.find_by(id: cookies.signed[:user_id]) or reject_unauthorized_connection
    end
  end
end
