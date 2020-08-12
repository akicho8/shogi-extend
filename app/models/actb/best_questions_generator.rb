module Actb
  class BestQuestionsGenerator
    attr_accessor :params

    def initialize(params)
      @params = {
      }.merge(params)

      if block_given?
        yield self
      end
    end

    def generate
      s = db_scope

      # DBから取得
      raise unless rule_info.best_questions_limit
      s = s.limit(rule_info.best_questions_limit).to_a

      ################################################################################ 取得後

      # まぜる(DBから取得の際に何かの順序に依存していた場合など)
      case rule_info.after_order
      when :shuffle
        s = s.shuffle
        # when :turn_max_asc
        #   s = s.sort_by(&:turn_max)
        # when :o_rate_asc
        #   s = s.sort_by { |e| e.o_rate || 0 }
      end

      # 最近投稿されたN個だけランダムに最初の方に登場させる
      # Nは○問先取値に大きく依存しているので率を指定する
      # 20問DBから取得して、10問先取で勝ちで、この値が 0.3 なら
      # 10*0.3 の3問を、新しい順にした20問なかから取得して
      # ランダムに先頭の方に移動する
      if v = rule_info.latest_move_to_top
        n = (rule_info.b_score_max_for_win * v).round # n = 移動させるか個数
        ary = s.sort_by(&:created_at).last(n)         # 取得済みの20問のなかから最新n件を取得
        ary.shuffle.each do |e|                       # ランダムに前方に移動
          s = [e] + (s - [e])
        end
      end

      s.collect(&:as_json_type3)
    end

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
        s = s.order("rand()")
      when :latest
        s = s.order(created_at: :desc)
      when :good
        s = s.order(Arel.sql("IFNULL(good_rate, 0) desc"))
      else
        raise ArgumentError, rule_info.select_order.inspect
      end

      s
    end

    private

    def rule_info
      params[:rule_info]
    end
  end
end
