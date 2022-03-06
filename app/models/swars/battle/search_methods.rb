module Swars
  class Battle
    concern :SearchMethods do
      class_methods do
        # def my_sampled_memberships(c)
        #   @my_sampled_memberships ||= c.current_swars_user.memberships
        # end

        # def op_sampled_memberships(c)
        #   @op_sampled_memberships ||= c.current_swars_user.op_memberships
        # end

        def sampled_memberships(c, m)
          m = m.joins(:battle)

          # FIXME: プレイヤー情報と条件を合わせるためハードコーディング
          # m = m.merge(Swars::Battle.win_lose_only) # 勝敗が必ずあるもの
          m = m.merge(Swars::Battle.newest_order)  # 直近のものから取得

          # FIXME: ↓これいらなくね？
          if true
            if v = c.query_info.lookup_one("sample")
              m = m.limit(v)          # N件抽出
            else
              # 指定しなくてもすでにuserで絞っているので爆発しない
            end
          end

          Swars::Membership.where(id: m.ids)
        end
      end

      included do
        scope :search, -> c {
          s = all

          if v = c.query_info.lookup(:ids)
            s = s.where(id: v)
          end

          if v = c.primary_record_key # バトルが指定されている
            s = s.where(key: v)
          end

          if v = c.query_info.lookup_one(:rule) || c.query_info.lookup_one("種類")
            s = s.rule_eq(v)
          end

          if e = c.query_info.lookup_op(:critical_turn) || c.query_info.lookup_op("開戦")
            s = s.where(arel_table[:critical_turn].public_send(e[:operator], e[:value]))
          end

          if e = c.query_info.lookup_op(:outbreak_turn) || c.query_info.lookup_op("中盤")
            s = s.where(arel_table[:outbreak_turn].public_send(e[:operator], e[:value]))
          end

          if e = c.query_info.lookup_op(:turn_max) || c.query_info.lookup_op("手数")
            s = s.where(arel_table[:turn_max].public_send(e[:operator], e[:value]))
          end

          if v = c.query_info.lookup_one(:final) || c.query_info.lookup_one("最後") || c.query_info.lookup_one("結末")
            s = s.where(arel_table[:final_key].eq(FinalInfo.fetch(v).key))
          end

          if c.current_swars_user
            selected = false

            my_sampled_memberships2 = c.current_swars_user.memberships

            if t = c.query_info.lookup_one("date") || c.query_info.lookup_one("日時") || c.query_info.lookup_one("日付")
              t = DateRange.parse(t)

              m = my_sampled_memberships2
              s = s.where(id: m.pluck(:battle_id))

              s = s.where(battled_at: t)
              selected = true
            end

            if v = c.query_info.lookup_one("judge") || c.query_info.lookup_one("勝敗")
              m = my_sampled_memberships2
              m = m.where(judge_key: JudgeInfo.fetch(v).key)
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if v = c.query_info.lookup_one("location") || c.query_info.lookup_one("先後")
              m = my_sampled_memberships2
              m = m.where(location_key: Bioshogi::Location.fetch(v).key)
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if v = c.query_info.lookup("tag") # 自分 戦法(AND)
              m = my_sampled_memberships2
              m = m.tagged_with(v)
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if v = c.query_info.lookup("or-tag") # 自分 戦法(OR)
              m = my_sampled_memberships2
              m = m.tagged_with(v, any: true)
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if v = c.query_info.lookup("vs-tag") # 相手 対抗
              m = sampled_memberships(c, c.current_swars_user.op_memberships)
              m = m.tagged_with(v)
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if v = c.query_info.lookup("vs-or-tag") # 相手 対抗
              m = sampled_memberships(c, c.current_swars_user.op_memberships)
              m = m.tagged_with(v, any: true)
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if v = c.query_info.lookup_one("vs-grade") # 段級
              grade = Grade.fetch(v)
              m = sampled_memberships(c, c.current_swars_user.op_memberships)
              m = m.where(grade: grade)
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if e = c.query_info.lookup_op("vs-grade-diff") || c.query_info.lookup_op("力差")
              m = my_sampled_memberships2
              m = m.where(Membership.arel_table[:grade_diff].public_send(e[:operator], e[:value]))
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if v = c.query_info.lookup("vs") || c.query_info.lookup("相手")
              users = Swars::User.where(user_key: v)
              m = c.current_swars_user.op_memberships.where(user: users)
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            unless selected
              s = s.joins(:memberships).merge(Membership.where(user_id: c.current_swars_user.id))
            end
          end

          s = s.includes(win_user: nil, memberships: {user: nil, grade: nil, taggings: :tag})

          s
        }
      end
    end
  end
end
