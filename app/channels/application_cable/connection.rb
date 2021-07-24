module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    identified_by :once_uuid    # ActionCableとの接続毎に変化するUUID

    def connect
      self.current_user = find_verified_user
      self.once_uuid = SecureRandom.uuid

      tags = []
      tags.concat(["ActionCable", once_uuid])
      if current_user
        tags << "#{current_user.id}:#{current_user.name}"
      end
      logger.add_tags(tags)

      # if current_user
      #   # current_user.actb_lobby_messages.create!(body: "*Connection#connect") if Rails.env.development?
      # end
    end

    def disconnect
      # Any cleanup work needed when the cable connection is cut.
      # if current_user
      #   # current_user.actb_lobby_messages.create!(body: "*Connection#disconnect") if Rails.env.development?
      # end

      # ActionCable.server.remote_connections.where(once_uuid: once_uuid).disconnect
    end

    private

    def find_verified_user
      # current_user_set で cookies に入れているので取れる
      if user_id = cookies.signed[:user_id]
        User.find_by(id: user_id) or reject_unauthorized_connection
      end
    end
  end
end
