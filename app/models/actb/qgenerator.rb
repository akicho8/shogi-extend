# -*- compile-command: "rails r 'Actb::Rule.setup; tp Actb::Rule'" -*-

module Actb
  # rails r "tp Actb::RuleInfo.first.generate"
  class Qgenerator
    attr_accessor :params

    def initialize(params = {}, &block)
      @params = {
        history_limit: 100,
        fill: true,
      }.merge(params)

      if block_given?
        yield self
      end
    end

    def generate
      s = db_scope
      s = [
        :func_history_reject,     # 最近解いたものは除外
        :func_limit,              # 絞る (結果は配列になっていること)
        :func_shuffle,            # シャッフル
        :func_latest_move_to_top, # 最近の問題は前に移動
        :func_fill,               # 足りない問題を足しておく
      ].inject(s) do |s, e|
        send(e, s)
      end
      s
    end

    # users たちが解いた直近の問題の中から N 件の問題IDsを取得
    def history_latest_questions
      s = Actb::History.all
      s = s.ox_mark_eq(:correct)
      if v = params[:users]
        s = s.where(user: v)
      end
      s = s.group(:question_id)
      s = s.order("MAX(created_at) DESC")
      if v = params[:history_limit]
        s = s.limit(v)
      end
      s
    end

    private

    def db_scope
      s = Question.all
      s = s.active_only

      # 指定の評価以上のもの(good_rateが空のものは1.0と見なす)
      if v = rule_info.good_rate_gteq
        s = s.where("(good_rate IS NULL OR (good_rate >= ?))", v)
      end

      # 指定の正解率以上のもの(o_rateが空のものは1.0と見なす)
      if v = rule_info.o_rate_gteq
        s = s.joins(:ox_record).where("(o_rate IS NULL OR (o_rate >= ?))", v)
      end

      # 指定の手数のもの(Rangeでも指定可)
      if v = rule_info.turn_max
        s = s.where(turn_max: v)
      end

      # 指定のタグ(オプション含めて指定する)
      if v = rule_info.tagged_with_args
        s = s.tagged_with(*v)
      end

      # 指定の種類(複数指定可)
      if v = Array(rule_info.lineage_keys_any).presence
        s = s.where(lineage: v.collect { |e| Lineage.fetch(e) })
      end

      # 取得するまえに順番をどうするか
      case rule_info.select_order
      when :o_rate_desc
        s = s.joins(:ox_record).order(o_rate: :desc)
      when :random
        s = s.order("RAND()")
      when :latest
        s = s.order(created_at: :desc)
      when :good
        s = s.order(Arel.sql("IFNULL(good_rate, 0) desc"))
      else
        raise ArgumentError, rule_info.select_order.inspect
      end

      s
    end

    def func_history_reject(s)
      if rule_info.history_reject
        s = s.where.not(id: history_latest_questions.pluck(:question_id))
      end
      s
    end

    def func_limit(s)
      raise unless rule_info.best_questions_limit
      s = s.limit(rule_info.best_questions_limit).to_a
    end

    def func_shuffle(s)
      # まぜる(DBから取得の際に何かの順序に依存していた場合など)
      case rule_info.after_order
      when :shuffle
        s = s.shuffle
        # when :turn_max_asc
        #   s = s.sort_by(&:turn_max)
        # when :o_rate_asc
        #   s = s.sort_by { |e| e.o_rate || 0 }
      end
      s
    end

    # 最近投稿されたN個だけランダムに最初の方に登場させる
    # Nは○問先取値に大きく依存しているので率を指定する
    # 20問DBから取得して、10問先取で勝ちで、この値が 0.3 なら
    # 10*0.3 の3問を、新しい順にした20問なかから取得して
    # ランダムに先頭の方に移動する
    def func_latest_move_to_top(s)
      if v = rule_info.latest_move_to_top
        n = (rule_info.b_score_max_for_win * v).round # n = 移動させるか個数
        ary = s.sort_by(&:created_at).last(n)         # 取得済みの20問のなかから最新n件を取得
        ary.shuffle.each do |e|                       # ランダムに前方に移動
          s = [e] + (s - [e])
        end
      end
      s
    end

    # [1, 2, 3, 4, 5, 6] とあって [1, 2, 3] をつくったらあと2つ足りないので
    # [1, 2, 3] を除いて [4, 5, 6] のなかから 2 つを選択してくっつける
    def func_fill(s)
      if params[:fill]
        rest = rule_info.best_questions_limit - s.size
        if rest >= 1
          s += db_scope.where.not(id: s.collect(&:id)).limit(rest).to_a
        end
      end
      s
    end

    def rule_info
      params[:rule_info]
    end
  end
end
