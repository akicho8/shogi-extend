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

          if v = query_info.lookup_one(:rule) || query_info.lookup_one("持ち時間") || query_info.lookup_one("種類")
            s = s.rule_eq(v)
          end

          # "Kouru_Abe 手合割:平手"
          # "Kouru_Abe 手合割:!平手"
          # "Kouru_Abe 手合割:-平手"
          # "Kouru_Abe 手合割:飛車落ち,角落ち"
          #
          # assert { case1("平手")              == ["平手"]               }
          # assert { case1("!平手")             == ["角落ち", "飛車落ち"] }
          # assert { case1("-平手")             == ["角落ち", "飛車落ち"] }
          # assert { case1("角落ち")            == ["角落ち"]             }
          # assert { case1("角落ち,飛車落ち")   == ["角落ち", "飛車落ち"] }
          # assert { case1("-角落ち,-飛車落ち") == ["平手"] }
          if v = query_info.lookup(:preset) || query_info.lookup("手合割") || query_info.lookup("手合")
            g = v.collect { |e|
              e.match(/(?<not>[!-])?(?<value>.*)/)
            }.compact.group_by { |e|
              !e[:not]
            }.transform_values { |e|
              e.collect { |e| e[:value] }
            }
            if v = g[true]
              s = s.preset_eq(v)
            end
            if v = g[false]
              s = s.preset_not_eq(v)
            end
          end

          if v = query_info.lookup_one(:xmode) || query_info.lookup_one("様式") || query_info.lookup_one("モード")
            s = s.xmode_eq(v)
          end

          if e = query_info.lookup_op(:critical_turn) || query_info.lookup_op("開戦")
            s = s.where(arel_table[:critical_turn].public_send(e[:operator], e[:value]))
          end

          if e = query_info.lookup_op(:outbreak_turn) || query_info.lookup_op("中盤")
            s = s.where(arel_table[:outbreak_turn].public_send(e[:operator], e[:value]))
          end

          if e = query_info.lookup_op(:turn_max) || query_info.lookup_op("手数")
            s = s.where(arel_table[:turn_max].public_send(e[:operator], e[:value]))
          end

          if v = query_info.lookup_one(:final) || query_info.lookup_one("最後") || query_info.lookup_one("結末")
            s = s.where(arel_table[:final_key].eq(FinalInfo.fetch(v).key))
          end

          if current_swars_user
            selected = false

            my_sampled_memberships2 = current_swars_user.memberships

            if t = query_info.lookup_one("date") || query_info.lookup_one("日時") || query_info.lookup_one("日付")
              t = DateRange.parse(t)

              m = my_sampled_memberships2
              s = s.where(id: m.pluck(:battle_id))

              s = s.where(battled_at: t)
              selected = true
            end

            if v = query_info.lookup_one("judge") || query_info.lookup_one("勝敗")
              m = my_sampled_memberships2
              m = m.where(judge_key: JudgeInfo.fetch(v).key)
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if v = query_info.lookup_one("location") || query_info.lookup_one("先後")
              m = my_sampled_memberships2
              m = m.where(location_key: Bioshogi::Location.fetch(v).key)
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if v = query_info.lookup("tag") # 自分 戦法(AND)
              m = my_sampled_memberships2
              m = m.tagged_with(v)
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if v = query_info.lookup("or-tag") # 自分 戦法(OR)
              m = my_sampled_memberships2
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

            if v = query_info.lookup_one("vs-grade") # 段級
              grade = Grade.fetch(v)
              m = sampled_memberships(query_info, current_swars_user.op_memberships)
              m = m.where(grade: grade)
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if e = query_info.lookup_op("vs-grade-diff") || query_info.lookup_op("力差")
              m = my_sampled_memberships2
              m = m.where(Membership.arel_table[:grade_diff].public_send(e[:operator], e[:value]))
              s = s.where(id: m.pluck(:battle_id))
              selected = true
            end

            if v = query_info.lookup("vs") || query_info.lookup("相手")
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
