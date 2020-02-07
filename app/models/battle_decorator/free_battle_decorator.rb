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

    def strategy_pack_for(location)
      player = heavy_parsed_info.mediator.player_at(location)
      sep = " #{params[:separator]} "
      max = params[:strategy_take_max]
      s = nil
      s ||= player.skill_set.attack_infos.take(max).join(sep).presence
      s ||= player.skill_set.defense_infos.take(max).join(sep).presence
      s ||= player.skill_set.note_infos.take(max).first.to_s.presence
      s ||= "不明"
      s.remove(/△|▲/)
    end

    def battle_result_str
      "#{battle.turn_max}手"
    end

    def total_seconds_for(location)
      heavy_parsed_info.mediator.player_at(location).personal_clock.total_seconds
    end
  end
end
