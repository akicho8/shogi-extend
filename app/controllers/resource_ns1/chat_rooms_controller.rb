module ResourceNs1
  class ChatRoomsController < ApplicationController
    include ModulableCrud::All

    prepend_before_action do
      # ChatUser.destroy_all
      # ChatRoom.destroy_all
      unless ChatRoom.exists?
        current_chat_user.owner_rooms.create!
        # ChatRoom.create!
      end
    end

    before_action do
    end

    def show
      @chat_room_app_params = {
        player_mode_moved_path: url_for([:resource_ns1, current_record, :kifu_valids, format: "json"]),
        current_chat_user: current_chat_user,
        chat_room: current_record,
        lifetime_infos: LifetimeInfo.collect(&:attributes),
      }
    end

    def raw_current_record
      super.tap do |e|
        e.room_owner ||= current_chat_user
        e.name ||= e.name_default
      end
    end

    def redirect_to_where
      [self.class.parent_name.underscore, current_record]
    end
  end
end
