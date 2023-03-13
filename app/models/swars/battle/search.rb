module Swars
  class Battle
    class Search
      def initialize(all, params)
        @all = all
        @params = params
        @q = params[:query_info]
        @user = params[:user]
        if @user
          @my = @user.memberships
          @op = @user.op_memberships
        end
      end

      def call
        scope.includes({
            :win_user => nil,
            :xmode    => nil,
            :rule     => nil,
            :final    => nil,
            :preset   => nil,
            :memberships => {
              :user     => nil,
              :grade    => nil,
              :location => nil,
              :style    => nil,
              :judge    => nil,
              :taggings => :tag,
            },
          })
      end

      def scope
        s = @all

        if v = q.lookup(:ids)
          s = s.where(id: v)
        end

        if v = params[:main_battle_key] # バトルが指定されている
          s = s.where(key: v.to_s)
        end

        begin
          if v = q.lookup(:xmode) || q.lookup("モード") || q.lookup("対局モード")
            s = s.xmode_ex(v)
          end

          if v = q.lookup(:rule) || q.lookup("持ち時間") || q.lookup("種類")
            s = s.rule_ex(v)
          end

          if v = q.lookup(:final) || q.lookup("結末") || q.lookup("最後")
            s = s.final_ex(v)
          end

          if v = q.lookup(:preset) || q.lookup("手合割") || q.lookup("手合")
            s = s.preset_ex(v)
          end
        end

        begin
          if e = q.lookup_op(:critical_turn) || q.lookup_op("開戦")
            s = s.where(Battle.arel_table[:critical_turn].public_send(e[:operator], e[:value]))
          end

          if e = q.lookup_op(:outbreak_turn) || q.lookup_op("中盤")
            s = s.where(Battle.arel_table[:outbreak_turn].public_send(e[:operator], e[:value]))
          end

          if e = q.lookup_op(:turn_max) || q.lookup_op("手数")
            s = s.where(Battle.arel_table[:turn_max].public_send(e[:operator], e[:value]))
          end
        end

        if @user
          @selected = false

          begin
            if v = q.lookup("judge") || q.lookup("勝敗")
              m = @my.judge_ex(v)
              s = s.where(id: m.pluck(:battle_id))
              @selected = true
            end

            if v = q.lookup("location") || q.lookup("先後")
              m = @my.location_ex(v)
              s = s.where(id: m.pluck(:battle_id))
              @selected = true
            end
          end

          begin
            if v = q.lookup("style") || q.lookup("自分の棋風") || q.lookup("棋風")
              m = @my.style_ex(v)
              s = s.where(id: m.pluck(:battle_id))
              @selected = true
            end
            if v = q.lookup("vs-style") || q.lookup("相手の棋風")
              m = @op.style_ex(v)
              s = s.where(id: m.pluck(:battle_id))
              @selected = true
            end
          end

          if t = q.lookup_one("date") || q.lookup_one("日付")
            if t = DateRange.parse(t)
              s = s.where(id: @my.pluck(:battle_id))
              s = s.where(battled_at: t)
              @selected = true
            end
          end

          begin
            if v = q.lookup("tag") # 自分 戦法(AND)
              m = @my.tagged_with(v)
              s = s.where(id: m.pluck(:battle_id))
              @selected = true
            end

            if v = q.lookup("or-tag") || q.lookup("any-tag")
              m = @my.tagged_with(v, any: true)
              s = s.where(id: m.pluck(:battle_id))
              @selected = true
            end

            if v = q.lookup("-tag") || q.lookup("exclude-tag")
              m = @my.tagged_with(v, exclude: true)
              s = s.where(id: m.pluck(:battle_id))
              @selected = true
            end
          end

          begin
            if v = q.lookup("vs-tag") # 相手 対抗
              m = @op.tagged_with(v)
              s = s.where(id: m.pluck(:battle_id))
              @selected = true
            end

            if v = q.lookup("vs-or-tag") || q.lookup("vs-any-tag")
              m = @op.tagged_with(v, any: true)
              s = s.where(id: m.pluck(:battle_id))
              @selected = true
            end

            if v = q.lookup("-vs-tag") || q.lookup("vs-exclude-tag")
              m = @op.tagged_with(v, exclude: true)
              s = s.where(id: m.pluck(:battle_id))
              @selected = true
            end
          end

          if v = q.lookup("vs-grade") || q.lookup("棋力") || q.lookup("相手の棋力")
            v = v.collect { |e| Grade.fetch(GradeInfo.fetch(e).key) }
            m = @op.where(grade: v)
            s = s.where(id: m.pluck(:battle_id))
            @selected = true
          end

          if e = q.lookup_op("vs-grade-diff") || q.lookup_op("力差") || q.lookup_op("棋力差")
            m = @my.where(Membership.arel_table[:grade_diff].public_send(e[:operator], e[:value]))
            s = s.where(id: m.pluck(:battle_id))
            @selected = true
          end

          if e = q.lookup_op("最大思考")
            m = @my.where(Membership.arel_table[:think_max].public_send(e[:operator], e[:value]))
            s = s.where(id: m.pluck(:battle_id))
            @selected = true
          end

          if e = q.lookup_op("最終思考")
            m = @my.where(Membership.arel_table[:think_last].public_send(e[:operator], e[:value]))
            s = s.where(id: m.pluck(:battle_id))
            @selected = true
          end

          if e = q.lookup_op("平均思考")
            m = @my.where(Membership.arel_table[:think_all_avg].public_send(e[:operator], e[:value]))
            s = s.where(id: m.pluck(:battle_id))
            @selected = true
          end

          if e = q.lookup_op("中盤以降の平均思考")
            m = @my.where(Membership.arel_table[:obt_think_avg].public_send(e[:operator], e[:value]))
            s = s.where(id: m.pluck(:battle_id))
            @selected = true
          end

          if e = q.lookup_op("中盤以降の最大連続即指し回数")
            m = @my.where(Membership.arel_table[:obt_auto_max].public_send(e[:operator], e[:value]))
            s = s.where(id: m.pluck(:battle_id))
            @selected = true
          end

          if v = q.lookup("vs") || q.lookup("相手") || q.lookup("対戦相手")
            users = User.where(user_key: v)
            m = @op.where(user: users)
            s = s.where(id: m.pluck(:battle_id))
            @selected = true
          end

          # 絞り込めていないときだけ自分の対局で絞る
          unless @selected
            s = s.joins(:memberships).merge(Membership.where(user_id: @user.id))
          end
        end

        s
      end

      private

      attr_reader :params
      attr_reader :q
    end
  end
end
