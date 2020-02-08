module BattleDecorator
  class FreeBattleDecorator < Base
    def preset_info
      @preset_info ||= heavy_parsed_info.preset_info
    end

    def tournament_name
      heavy_parsed_info.header["棋戦"]
    end

    def player_name_for(location)
      location = Bioshogi::Location[location]
      heavy_parsed_info.header.to_h.values_at(*location.call_names).compact.first
    end

    def strategy_pack_core(location)
      player = heavy_parsed_info.mediator.player_at(location)
      sep = " #{params[:separator]} "
      max = params[:strategy_take_max]
      s = nil
      s ||= player.skill_set.attack_infos.take(max).join(sep).presence
      s ||= player.skill_set.defense_infos.take(max).join(sep).presence
      s ||= player.skill_set.note_infos.take(max).first.to_s.presence
    end

    # 1手も指さないときは "0手で後手の勝ち" になる
    # "#{battle.turn_max}手" でもよい
    #
    # 自力で作る場合
    # if location = heavy_parsed_info.mediator.win_player.location
    #   str = player_name_for(location)
    # end
    def battle_result_str
      str = heavy_parsed_info.judgment_message
      str = str.lines.grep_v(/^\*/).join # KIFの*で始まるコメントを含む場合があるため除外する
      str = str.remove(/^まで/)

      if true
        # 「先手」を実際の名前に置き換える場合
        Bioshogi::Location.each do |location|
          if name = player_name_for(location).presence
            grade = grade_name_for(location) # FreeBattle の場合、常に空なので意味ない
            str = str.gsub(/#{location.call_names.join("|")}/, "#{grade}#{name}")
          end
        end
      end

      str
    end

    def total_seconds_for(location)
      heavy_parsed_info.mediator.player_at(location).personal_clock.total_seconds
    end
  end
end
