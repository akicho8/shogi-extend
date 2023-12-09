module ShareBoard
  class Responder1Job < ApplicationJob
    queue_as :default

    def perform(params)
      # AppLog.info(body: params.inspect)
      # {
      #   "from_connection_id"=>"espq1cQtyB3",
      #   "from_user_name"=>"alice",
      #   "performed_at"=>1678970689204,
      #   "ua_icon_key"=>"mac",
      #   "ac_events_hash"=>{"initialized"=>1,
      #     "connected"=>2,
      #     "received"=>16,
      #     "disconnected"=>1},
      #   "debug_mode_p"=>true,
      #   "from_avatar_path"=>"/assets/human/0005_fallback_avatar_icon-f076233f605139a9b8991160e1d79e6760fe6743d157446f88b12d9dae5f0e03.png",
      #   "message"=>"@gpt hello",
      #   "message_scope_key"=>"is_message_scope_public",
      #   "action"=>"message_share",
      #   :room_code=>"dev_room",
      # }
      ShareBoard::ChatAi::Responder::Responder1.new(params).call
    end
  end
end
