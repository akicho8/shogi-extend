module Wkbk
  class NotificationBroadcastJob < ApplicationJob
    queue_as :default

    # FIXME: 全員に通知している。これが重いのであれば削除してもよい
    def perform(notification)
      ActionCable.server.broadcast("wkbk/lobby_channel", bc_action: :notification_singlecasted, bc_params: { notification: notification.as_json_type11 })
    end
  end
end
