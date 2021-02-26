module Swars
  concern :MembershipTimeChartMethods do
    # 時間切れで自分が負けたとき何秒放置したかを返す
    # これまで8分使ったとしてルールが10分だとすれば2分放置したことがわかる
    # ただし10秒ルールは除く
    def leave_alone_seconds
      @leave_alone_seconds ||= -> {
        if battle.final_info.key == :TIMEOUT
          if judge_info.key == :lose
            if battle.rule_info.related_time_p
              battle.rule_info.life_time - battle.raw_sec_list(location).sum # sec_list を使うと無限ループするので注意。補正してない raw_sec_list を使うこと
            end
          end
        end
      }.call
    end

    # 使った秒数のリスト
    def sec_list
      @sec_list ||= -> {
        list = battle.raw_sec_list(location)

        # 時間切れまでの放置時間があれば追加する
        if v = leave_alone_seconds
          list += [v]
        end

        list
      }.call
    end

    # [{:x=>1, :y=>10 seconds}, {:x=>3, :y=>20 seconds}]
    def time_chart_xy_list
      @time_chart_xy_list ||= battle.time_chart_xy_list(location)
    end
  end
end
