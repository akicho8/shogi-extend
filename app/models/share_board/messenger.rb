# -*- compile-command: "rails runner 'ShareBoard::Messenger.new.call'" -*-
# どこからでも簡単にチャットに発言する
#
# rails r 'ShareBoard::Messenger.new.call("こんにちは")'
#
module ShareBoard
  class Messenger
    attr_accessor :params

    def initialize(params = {})
      @params = {
        :from_user_name => "運営",
        :room_code      => "dev_room",
      }.merge(params)
    end

    def call(message = nil, bc_params = {})
      bc_params = {
        :message      => message || "#{Time.current}",
        :performed_at => Time.current.to_i,
      }.merge(params, bc_params)

      Broadcaster.new(room_code).call("message_share_broadcasted", bc_params)
    end

    def room_code
      params[:room_code]
    end
  end
end
