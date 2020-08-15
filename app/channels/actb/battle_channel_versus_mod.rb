module Actb
  concern :BattleChannelVersusMod do
    included do
    end

    class_methods do
    end

    # 盤面を共有する
    def vs_func_play_board_share(data)
      data = data.to_options
      broadcast(:vs_func_play_board_share_broadcasted, data)
    end
  end
end
