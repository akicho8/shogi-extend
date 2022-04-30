module Swars
  class Battle
    concern :SearchMethods do
      class_methods do
        # def my_sampled_memberships(c)
        #   @my_sampled_memberships ||= current_swars_user.memberships
        # end

        # def op_sampled_memberships(c)
        #   @op_sampled_memberships ||= current_swars_user.op_memberships
        # end

        def sampled_memberships(query_info, m)
          m = m.joins(:battle)

          # FIXME: プレイヤー情報と条件を合わせるためハードコーディング
          # m = m.merge(Swars::Battle.win_lose_only) # 勝敗が必ずあるもの
          m = m.merge(Swars::Battle.newest_order)  # 直近のものから取得

          # FIXME: ↓これいらなくね？
          if true
            if v = query_info.lookup_one("sample")
              m = m.limit(v)          # N件抽出
            else
              # 指定しなくてもすでにuserで絞っているので爆発しない
            end
          end

          Swars::Membership.where(id: m.ids)
        end
      end

      included do
        scope :search, -> params {
          query_info = params[:query_info]
          current_swars_user = params[:current_swars_user]

          s = all

          if v = query_info.lookup(:ids)
            s = s.where(id: v)
          end

          if v = params[:primary_record_key] # バトルが指定されている
            s = s.where(key: v)
          end

          begin
            if v = query_info.lookup(:xmode) || query_info.lookup("モード") || query_info.lookup("対局モード")
              s = s.xmode_ex(v)
            end

            if v = query_info.lookup(:rule) || query_info.lookup("持ち時間") || query_info.lookup("種類")
              s = s.rule_ex(v)
            end

            if v = query_info.lookup(:final) || query_info.lookup("結末") || query_info.lookup("最後")
              s = s.final_ex(v)
            end

            if v = query_info.lookup(:preset) || query_info.lookup("手合割") || query_info.lookup("手合")
              s = s.preset_ex(v)
            end
          end

          begin
            if e = query_info.lookup_op(:critical_turn) || query_info.lookup_op("開戦")
              s = s.where(arel_table[:critical_turn].public_send(e[:operator], e[:value]))
            end

            if e = query_info.lookup_op(:outbreak_turn) || query_info.lookup_op("中盤")
              s = s.where(arel_table[:outbreak_turn].public_send(e[:operator], e[:value]))
            end

            if e = query_info.lookup_op(:turn_max) || query_info.lookup_op("手数")
              s = s.where(arel_table[:turn_max].public_send(e[:operator], e[:value]))
            end
          end

          if current_swars_user
            selected = false

            my_memberships = current_swars_user.memberships

            begin
              if v = query_info.lookup("judge") || query_info.lookup("勝敗")
                m = my_memberships
                m = m.judge_ex(v)
                s = s.where(id: m.pluck(:battle_id))
                selected = true
              end

              if v = query_info.lookup("location") || query_info.lookup("先後")
                m = my_memberships
                m = m.location_ex(v)
                s = s.where(id: m.pluck(:battle_id))
                selected = true
              end
            end

            if t = query_info.lookup_one("date") || query_info.lookup_one("日時") || query_info.lookup_one("日付")
              t = DateRange.parse(t)

              m = my_memberships
              s = s.where(id: m.pluck(:battle_id))

              s = s.where(battled_at: t)
              selected = true
            end

            if v = query_info.lookup("tag") # 自分 戦法(AND)
              m = my_memberships
              m = m.tagged_with(v)
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if v = query_info.lookup("or-tag") # 自分 戦法(OR)
              m = my_memberships
              m = m.tagged_with(v, any: true)
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if v = query_info.lookup("vs-tag") # 相手 対抗
              m = sampled_memberships(query_info, current_swars_user.op_memberships)
              m = m.tagged_with(v)
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if v = query_info.lookup("vs-or-tag") # 相手 対抗
              m = sampled_memberships(query_info, current_swars_user.op_memberships)
              m = m.tagged_with(v, any: true)
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if v = query_info.lookup("vs-grade") || query_info.lookup("棋力") || query_info.lookup("相手の棋力")
              v = v.collect { |e| Grade.fetch(GradeInfo.fetch(e).key) }
              m = sampled_memberships(query_info, current_swars_user.op_memberships)
              m = m.where(grade: v)
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if e = query_info.lookup_op("vs-grade-diff") || query_info.lookup_op("力差") || query_info.lookup_op("棋力差")
              m = my_memberships
              m = m.where(Membership.arel_table[:grade_diff].public_send(e[:operator], e[:value]))
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if e = query_info.lookup_op("最大思考")
              m = my_memberships
              m = m.where(Membership.arel_table[:think_max].public_send(e[:operator], e[:value]))
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if e = query_info.lookup_op("最終思考")
              m = my_memberships
              m = m.where(Membership.arel_table[:think_last].public_send(e[:operator], e[:value]))
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if e = query_info.lookup_op("平均思考")
              m = my_memberships
              m = m.where(Membership.arel_table[:think_all_avg].public_send(e[:operator], e[:value]))
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if e = query_info.lookup_op("中盤以降平均思考")
              m = my_memberships
              m = m.where(Membership.arel_table[:obt_think_avg].public_send(e[:operator], e[:value]))
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if e = query_info.lookup_op("中盤以降最大連続即指し回数")
              m = my_memberships
              m = m.where(Membership.arel_table[:obt_auto_max].public_send(e[:operator], e[:value]))
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if v = query_info.lookup("vs") || query_info.lookup("相手") || query_info.lookup("対戦相手")
              users = Swars::User.where(user_key: v)
              m = current_swars_user.op_memberships.where(user: users)
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            # なんでこんなんいるんだっけ？
            unless selected
              s = s.joins(:memberships).merge(Membership.where(user_id: current_swars_user.id))
            end
          end

          s = s.includes(win_user: nil, memberships: {user: nil, grade: nil, taggings: :tag})

          s
        }
      end
    end
  end
end
