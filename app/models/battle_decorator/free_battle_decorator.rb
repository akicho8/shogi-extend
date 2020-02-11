module BattleDecorator
  class FreeBattleDecorator < Base
    def preset_info
      @preset_info ||= heavy_parsed_info.preset_info
    end

    def tournament_name
      if md = tournament_name_md
        md["tournament_name"]
      end
    end

    def rule_name
      if md = tournament_name_md
        md["rule_name"]
      end
    end

    def player_name_for(location)
      if md = player_name_md(location)
        md["player_name"]
      end
    end

    def grade_name_for(location)
      if md = player_name_md(location)
        if s = md["grade_name"]
          if md = s.match(/\((.*)\)/) # "(R123)" → "R123"
            s = md.captures.first
          end
          s
        end
      end
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
            # grade = grade_name_for(location) # FreeBattle の場合、常に空なので意味ない
            grade = nil
            str = str.gsub(/#{location.call_names.join("|")}/, " #{grade}#{name} ")
          end
        end
      end

      str
    end

    def total_seconds_for(location)
      heavy_parsed_info.mediator.player_at(location).personal_clock.total_seconds
    end

    private

    def normalized_full_tournament_name
      normalize_str(heavy_parsed_info.header["棋戦"])
    end

    def tournament_name_md
      normalized_full_tournament_name.match(/(?<tournament_name>.*)\s*\((?<rule_name>.*)\)\z/)
    end

    def full_player_name(location)
      location = Bioshogi::Location[location]
      heavy_parsed_info.header.to_h.values_at(*location.call_names).compact.first.to_s
    end

    def player_name_md(location)
      full_player_name(location).match(/(?<player_name>.+?)\s*(?<grade_name>\(.+\)|#{Swars::GradeInfo.keys.join("|")})?\z/) # #<MatchData "niwapin(2298)" player_name:"niwapin" grade_name:"2298">
    end
  end
end
