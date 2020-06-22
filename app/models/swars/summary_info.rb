module Swars
  class SummaryInfo
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def secret_summary
      stat = Hash.new(0)

      if (d = judge_count_for(:lose)).nonzero?
        ms_a = ms_group["切断した"] || []
        c = ms_a.size
        # count_set(stat, "切断回数", c, alert_p: c.nonzero?, memberships: ms_a)
        parcentage_set(stat, "切断率", c, d, danger_p: c.nonzero?, tooltip: "切断回数 / 負け数", memberships: ms_a)
      end

      if (d = judge_count_for(:win)).nonzero?
        ms_a = cheat_memberships
        c = ms_a.size
        # count_set(stat, "棋神召喚疑惑", c, alert_p: c.nonzero?, memberships: cheat_memberships)
        parcentage_set(stat, "棋神召喚疑惑率", c, d, alert_p: c.nonzero?, memberships: ms_a)
      end

      if (d = judge_count_for(:lose)).nonzero?
        ms_a = ms_group["投了した"] || []
        c = ms_a.size
        parcentage_set(stat, "投了率", c, d, warn_p: c.fdiv(d) < 0.25, tooltip: "投了回数 / 負け数", memberships: ms_a)
      end

      # turn = memberships.collect { |e| e.battle.turn_max }.max
      # count_set(stat, "【#{rule_info.name}】最長手数", turn, alert_p: turn && turn >= 200, suffix: "手")

      if true
        # latest_record = user.battles.reorder(created_at: :desc).take
        # t = latest_record.created_at
        t = Time.current
        n_days = 7
        range = t.ago(n_days.days)..t
        avg = user.battles.where(created_at: range).count.fdiv(n_days).round(2)
        count_set(stat, "直近1週間での1日平均対局数", avg, great_p: avg >= 10, suffix: "戦")
      end

      RuleInfo.each do |rule_info|
        ships = memberships.find_all { |e| e.battle.rule_info == rule_info }

        if ships.present?
          if rule_info.related_time_p
            ms = ships.max_by { |e| e.sec_list.max.to_i }
            sec = ms.sec_list.max.to_i
            sec_set(stat, "【#{rule_info.name}】最大長考", sec, alert_p: sec && sec >= rule_info.short_leave_alone, membership: ms)

            ms = ships.max_by { |e| e.sec_list.last.to_i }
            sec = ms.sec_list.last.to_i
            sec_set(stat, "【#{rule_info.name}】最終着手の最長", sec, danger_p: sec && sec >= rule_info.short_leave_alone, membership: ms)

            ms_a = ships.find_all { |e| e.judge_info.key == :lose && e.sec_list.last.to_i >= rule_info.short_leave_alone }
            count = ms_a.count
            count_set(stat, "【#{rule_info.name}】最終着手に#{sec_to_human(rule_info.short_leave_alone)}以上かけて負け", count, danger_p: count.nonzero?, memberships: ms_a)

            ms_a = ships.find_all { |e| e.summary_key == "詰ました" && e.sec_list.last >= rule_info.short_leave_alone }
            count = ms_a.count
            count_set(stat, "【#{rule_info.name}】1手詰を#{sec_to_human(rule_info.short_leave_alone)}以上かけて詰ました", count, danger_p: count.nonzero?, memberships: ms_a)

            scope = ships.find_all { |e| e.summary_key == "詰ました" }
            if ms = scope.max_by { |e| e.sec_list.last.to_i }
              sec = ms.sec_list.last.to_i
              sec_set(stat, "【#{rule_info.name}】1手詰勝ちのときの着手最長", sec, danger_p: sec && sec >= rule_info.short_leave_alone, membership: ms)
            end

            scope = ships.find_all { |e| e.summary_key == "切れ負け" }
            if ms = scope.max_by { |e| e.rest_sec }
              sec = ms.rest_sec.to_i
              sec_set(stat, "【#{rule_info.name}】切れ負けるときの思考時間最長", sec, danger_p: sec && sec >= rule_info.short_leave_alone, membership: ms)
            end

            ms_a = ships.find_all { |e| e.summary_key == "切れ負け" && e.rest_sec >= rule_info.short_leave_alone }
            count = ms_a.count
            count_set(stat, "【#{rule_info.name}】#{sec_to_human(rule_info.short_leave_alone)}以上かけて切れ負け", count, danger_p: count.nonzero?, memberships: ms_a)
          end

          # e.summary_key == "投了した" || e.summary_key == "詰まされた" }.presence
          # if scope = ships.find_all { |e| e.judge_info.key == :lose }
          scope = ships.find_all { |e| e.summary_key == "投了した" || e.summary_key == "詰まされた" }.presence # { |e| e.judge_info.key == :lose } の判定だと切断負けも含まれてしまう
          tooltip = "切断を除く"
          if scope
            if ms = scope.min_by { |e| e.battle.turn_max }
              turn = ms.battle.turn_max
              count_set(stat, "【#{rule_info.name}】負け最短手数", turn, alert_p: turn && turn <= rule_info.most_min_turn_max_limit, suffix: "手", membership: ms, tooltip: tooltip)
            end
            if ms = scope.min_by { |e| e.total_seconds }
              sec = ms.total_seconds
              sec_set(stat, "【#{rule_info.name}】負け最短時間", sec, alert_p: sec && sec <= rule_info.resignation_limit, membership: ms, tooltip: tooltip)
            end
          end

          if scope = ships.find_all { |e| e.judge_info.key == :win }.presence
            if ms = scope.max_by { |e| e.battle.turn_max }
              turn = ms.battle.turn_max
              count_set(stat, "【#{rule_info.name}】勝ち最長手数", turn, warn_p: turn && turn >= 200, suffix: "手", membership: ms)
            end
            if ms = scope.min_by { |e| e.battle.turn_max }
              turn = ms.battle.turn_max
              count_set(stat, "【#{rule_info.name}】勝ち最短手数", turn, warn_p: false, suffix: "手", membership: ms)
            end
            if rule_info.key == :ten_sec
              if ms = scope.max_by { |e| e.total_seconds }
                sec = ms.total_seconds
                sec_set(stat, "【#{rule_info.name}】勝ち最長時間", sec, warn_p: sec && sec >= 10.minutes, membership: ms)
              end
            end
          end

          if ms = ships.max_by { |e| e.battle.turn_max }
            turn = ms.battle.turn_max
            count_set(stat, "【#{rule_info.name}】最長手数", turn, warn_p: turn && turn >= 200, suffix: "手", membership: ms)
          end

          # scope = ships.find_all { |e| e.summary_key == "投了した" }
          # most_min_turn_max = scope.collect { |e| e.sec_total }.min
          # sec_set(stat, "【#{rule_info.name}】1手詰勝ちのときの着手最長", sec, warn_p: sec && sec < rule_info.resignation_limit)
        end
      end

      stat
    end

    def basic_summary
      stat = Hash.new(0)

      count_set(stat, "サンプル対局数", memberships.count, url: query_path("tag:#{user.key}"), suffix: "")

      ms_a = judge_group_memberships(:win)
      parcentage_set(stat, "勝率", ms_a.size, win_lose_total_count, great_p: win_rate >= 0.6, memberships: ms_a)

      win_range_for(stat, win_range_key: "格上", key: :win)
      win_range_for(stat, win_range_key: "同格", key: :win)
      win_range_for(stat, win_range_key: "格下", key: :win)

      ChartTagInfo.each do |e|
        scope = main_scope.tagged_with(e.name, on: :note_tags)
        d = scope.count
        if d >= 1
          ms_a = scope.where(judge_key: "win")
          c = ms_a.count
          rate = c.fdiv(d)
          parcentage_set(stat, "#{e.name}の勝率", c, d, great_p: rate >= 0.6, memberships: ms_a)
        end
      end

      win_range_for(stat, win_range_key: "格上", key: :lose)
      win_range_for(stat, win_range_key: "同格", key: :lose)
      win_range_for(stat, win_range_key: "格下", key: :lose)

      if memberships.present?
        c = memberships.sum { |e| e.battle.turn_max }.fdiv(memberships.size).round
        count_set(stat, "平均手数", c, warn_p: c < 70, suffix: "手")
      end

      [0, 50, 100, 150, 200, Float::INFINITY].each_cons(2) do |s, e|
        range = s...e
        ms_a = memberships.find_all { |e| range.cover?(e.battle.turn_max) }
        c = ms_a.size
        if c.nonzero?
          count_set(stat, s.zero? ? "#{e}手未満" : "#{s}手以上", c, memberships: ms_a, great_p: s >= 200)
        end
      end

      JudgeInfo.each do |e|
        ms_a = judge_group_memberships(e.key)
        c = ms_a.size
        count_set(stat, e.name, c, memberships: ms_a)
      end

      ms_group.each do |summary_key, ms_a|
        c = ms_a.size
        count_set(stat, summary_key, c, memberships: ms_a)
      end

      # stat.delete("切断した")
      # suffix_add(stat)

      stat
    end

    def tactic_summary_for(key)
      v = memberships.flat_map(&:"#{key}_tag_list")
      v = v.group_by(&:itself).transform_values(&:size) # TODO: ruby 2.6 の新しいメソッドで置き換えれるはず
      v = v.sort_by { |k, v| -v }
      v.inject({}) do |a, (key, val)|
        path = query_path("#{user.key} muser:#{user.key} ms_tag:#{key}", import_skip: true)
        if Bioshogi::TacticInfo.flat_lookup(key)
          key = h.link_to(key, Rails.application.routes.url_helpers.url_for([:tactic_note, id: key, only_path: true]), :class => "no-decoration")
        end
        val = h.link_to(val, path)
        a.merge(key => val)
      end
    end

    private

    def win_range_for(stat, params = {})
      # 格上 or 格下
      win_range_info = WinRangeInfo.fetch(params[:win_range_key])
      win_lose_info = WinLoseInfo.fetch(params[:key])

      scope = memberships.find_all { |e| e.grade.priority.public_send(win_range_info.op, e.opponent.grade.priority) }
      d = scope.size
      if d >= 1
        ms_a = scope.find_all { |e| e.judge_key == win_lose_info.key.to_s }
        if win_lose_info.key == :win
          rate = ms_a.size.fdiv(d)
          # warn_p = win_lose_info.key == :win && !win_range_info.win_range.cover?(rate) || win_lose_info.key == :lose && win_range_info.win_range.cover?(rate)
          parcentage_set(stat, "【対#{win_range_info.name}】勝率", ms_a.size, d, tooltip: "#{win_lose_info.name}数 / #{win_range_info.name}との対局数", great_p: rate >= win_range_info.rate_max, memberships: ms_a)
        else
          count_set(stat, "【対#{win_range_info.name}】#{win_lose_info.name}数", ms_a.size, memberships: ms_a)
        end
      end
    end

    # def win_a_superior(key, op)
    #   @win_a_superior = {}
    #   @win_a_superior[[key, op]] = memberships.find_all { |e| e.judge_info.key == key && e.grade.priority.public_send(op, e.opponent.grade.priority) }
    # end

    def main_scope
      user.memberships.includes(:battle, :user, :grade)
    end

    def memberships
      @memberships ||= main_scope.to_a
    end

    def ms_group
      @ms_group ||= memberships.inject({}) do |a, e|
        a[e.summary_key] ||= []
        a[e.summary_key] << e
        a
      end
    end

    def cheat_memberships
      @cheat_memberships ||= memberships.find_all { |e| e.swgod_10min_winner_used? }
    end

    # def suffix_add(stat)
    #   stat
    #   # stat.transform_values do |e|
    #   #   if e.kind_of? Integer
    #   #     "#{e}回"
    #   #   else
    #   #     e
    #   #   end
    #   # end
    # end

    def judge_count_for(key)
      judge_group_memberships(key).size
    end

    def judge_group_memberships(key)
      @judge_group_memberships ||= memberships.group_by(&:judge_key)
      @judge_group_memberships[key.to_s] || []
    end

    def win_rate
      @win_rate ||= judge_count_for(:win).fdiv(win_lose_total_count)
    end

    def win_lose_total_count
      @win_lose_total_count ||= judge_count_for(:win) + judge_count_for(:lose)
    end

    def count_set(stat, key, value, options = {})
      if value.zero? && false
        return
      end

      options[:suffix] ||= "回"
      value = [value, options[:suffix]].join
      value = link_set(value, options)

      stat[key_wrap(key, options)] = value
    end

    def sec_set(stat, key, value, options = {})
      if value.nil?
        return
      end

      value = sec_to_human(value)
      value = link_set(value, options)

      stat[key_wrap(key, options)] = value
    end

    def link_set(value, options = {})
      ids = nil
      url = nil

      case
      when v = options[:url]
        url = v
      when membership = options[:membership]
        ids = [membership.battle.id]
      when memberships = options[:memberships].presence
        ids = memberships.collect { |e| e.battle.id }
      end

      if ids
        ids = ids.join(",")
        url = query_path("ids:#{ids}")
      end

      if url
        value = h.link_to(value, url)
      end

      value
    end

    def query_path(query, options = {})
      Rails.application.routes.url_helpers.url_for([:swars, :battles, options.merge(query: query, only_path: true, per: Kaminari.config.max_per_page)])
    end

    def parcentage_set(stat, key, numerator, denominator, options = {})
      if denominator.zero?
        return
      end

      value = parcentage(numerator, denominator)
      value = link_set(value, options)

      stat[key_wrap(key, options)] = value
    end

    def key_wrap(key, options = {})
      if v = options[:tooltip]
        key = h.content_tag("b-tooltip", key, label: v, position: "is-top", size: "is-small") # multilined: false
      end

      if options[:alert_p] || options[:great_p] || options[:warn_p]
        key = Icon.icon_tag("alert-circle", size: "is-small", :class => "has-text-danger") + key
      end
      if options[:danger_p]
        key = Icon.icon_tag("alert-circle", size: "is-small", :class => "has-text-danger") + key
      end

      key
    end

    def parcentage(numerator, denominator)
      if denominator.nonzero?
        # if numerator.zero?
        #   "0%"
        # else
        v = parcentage_rate(numerator, denominator)
        "#{v}% (#{numerator}/#{denominator})"
      end
    end

    def parcentage_rate(numerator, denominator)
      if denominator.nonzero?
        (numerator * 100).fdiv(denominator).round(2)
      end
    end

    def sec_to_human(v)
      if v.nil?
        return ""
      end
      if v.zero?
        return "0秒"
      end
      min, sec = v.divmod(1.minutes)
      list = []
      if min.nonzero?
        list << "#{min}分"
      end
      if sec.nonzero?
        list << "#{sec}秒"
      end
      list.join
    end

    def h
      @h ||= ApplicationController.new.view_context
    end
  end
end
