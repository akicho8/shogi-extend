module Swars
  concern :MembershipTimeChartMethods do
    # 時間切れで自分が負けたとき何秒放置したかを返す
    # これまで8分使ったとしてルールが10分だとすれば2分放置したことがわかる
    # ただし10秒ルールは除く
    def leave_alone_seconds
      @leave_alone_seconds ||= yield_self do
        if battle.final_info.key == :TIMEOUT
          if judge_info.key == :lose
            if battle.rule_info.related_time_p
              if v = battle.rule_info.life_time
                v - battle.raw_sec_list(location_info).sum # sec_list を使うと無限ループするので注意。補正してない raw_sec_list を使うこと
              end
            end
          end
        end
      end
    end

    # 使った秒数のリスト
    def sec_list
      @sec_list ||= yield_self do
        list = battle.raw_sec_list(location_info)

        # 時間切れまでの放置時間があれば追加する
        if v = leave_alone_seconds
          list += [v]
        end

        list
      end
    end

    # [{:x=>1, :y=>10 seconds}, {:x=>3, :y=>20 seconds}]
    def time_chart_xy_list(accretion)
      battle.time_chart_xy_list2(location_info, accretion)
    end
  end
end
