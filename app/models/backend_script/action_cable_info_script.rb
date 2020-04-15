module BackendScript
  class ActionCableInfoScript < ::BackendScript::Base
    self.category = "その他"
    self.script_name = "ActionCable 接続情報"

    def script_body
      ActionCable.server.open_connections_statistics.sort_by { |e| e[:started_at] }.reverse
      # ActionCable.server.connections.size
      # ActionCable.server.connections
    end
  end
end
