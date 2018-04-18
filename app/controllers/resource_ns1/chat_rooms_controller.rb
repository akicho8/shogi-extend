module ResourceNs1
  class ChatRoomsController < ApplicationController
    include ModulableCrud::All

    prepend_before_action do
      unless ChatRoom.exists?
        ChatRoom.create!
      end
    end

    def show
      @chat_room_app_params = {
        player_mode_moved_path: url_for([:resource_ns1, current_record, :kifu_valids, format: "json"]),
        current_chat_user: current_chat_user,
        chat_room: current_record,
      }
    end

    def current_chat_user
      @current_chat_user ||= ChatUser.find_by(id: cookies.signed[:chat_user_id])
      unless @current_chat_user
        @current_chat_user = ChatUser.create!(name: "#{ChatUser.count.next}さん")
      end
      cookies.signed[:chat_user_id] = @current_chat_user.id
      @current_chat_user
    end

    helper_method :current_chat_user


    def raw_current_record
      super.tap do |e|
        e.name ||= e.name_default
      end
    end

    def redirect_to_where
      [self.class.parent_name.underscore, current_record]
    end
  end
end
