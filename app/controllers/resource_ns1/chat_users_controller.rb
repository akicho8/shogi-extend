module ResourceNs1
  class ChatUsersController < ApplicationController
    include ModulableCrud::All

    # prepend_before_action do
    #   unless ChatRoom.exists?
    #     ChatRoom.create!
    #   end
    # end
    #
    # before_action do
    # end
    #
    # def show
    #   @chat_room_app_params = {
    #     player_mode_moved_path: url_for([:resource_ns1, current_record, :kifu_valids, format: "json"]),
    #     current_chat_user: current_chat_user,
    #     chat_room: current_record,
    #   }
    # end
    #
    # def raw_current_record
    #   super.tap do |e|
    #     e.name ||= e.name_default
    #   end
    # end
    #
    def redirect_to_where
      [:resource_ns1, :chat_rooms]
    end
  end
end
