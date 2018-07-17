module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags current_user.name
    end

    def disconnect
      # Any cleanup work needed when the cable connection is cut.
    end

    private

    def find_verified_user
      verified_user = Colosseum::User.find_by(id: cookies.signed[:user_id])
      # unless verified_user
      #   verified_user = Colosseum::User.create!(name: "#{User.count.next}さん")
      # end
      unless verified_user
        reject_unauthorized_connection
      end
      # cookies.signed[:user_id] = verified_user.id
      verified_user
    end
  end
end
