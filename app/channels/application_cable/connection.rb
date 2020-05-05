module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      if current_user
        logger.add_tags current_user.name
        Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, "ログインしている"])
      else
        Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__, "ログインしていない"])
      end
    end

    def disconnect
      # Any cleanup work needed when the cable connection is cut.
      Rails.logger.debug(["#{__FILE__}:#{__LINE__}", __method__])
    end

    private

    def find_verified_user
      # current_user_set で cookies に入れているので取れる
      Colosseum::User.find_by(id: cookies.signed[:user_id]) or reject_unauthorized_connection
    end
  end
end
