# http://localhost:4000/lab/admin/action-cable-info

module QuickScript
  module Admin
    class ActionCableInfoScript < Base
      self.title = "ActionCable 接続状況"
      self.description = "ActionCable に現在接続しているクライアントの情報を表示する"
      self.json_link = true

      def as_general_json
        stats
      end

      def call
        stats
      end

      def title
        "#{super} (#{stats.size})"
      end

      def stats
        @stats ||= ActionCable.server.open_connections_statistics.sort_by { |e| e[:started_at] }.reverse
      end
    end
  end
end
