# -*- frozen_string_literal: true -*-
module Swars
  module UserInfo
    class Main
      JUDGE_INFO_RECORDS_INCLUDE_EMPTY_LABEL = true # 勝ち負けのラベルの並びを共通化させるため「投了」がなくても「投了」を含める

      attr_accessor :user
      attr_accessor :params

      cattr_accessor(:max_of_max) { 200 }

      cattr_accessor(:default_params) {
        {
          :sample_max => 50, # データ対象直近n件
          :ox_max     => 17, # 表示勝敗直近n件
        }
      }

      def initialize(user, params = {})
        @user = user
        @params = default_params.merge(params)
      end

      # http://localhost:3000/w.json?query=kinakom0chi&format_type=user
      # http://localhost:3000/w.json?query=DevUser1&format_type=user
      # http://localhost:3000/w.json?query=DevUser1&format_type=user&debug=true
      # https://www.shogi-extend.com/w.json?query=kinakom0chi&format_type=user
      def to_hash
        {}.tap do |hash|

          hash[:onetime_key] = SecureRandom.hex # vue.js の :key に使うため

          hash[:sample_max] = sample_max      # サンプル数(棋譜一覧で再検索するときに "sample:n" として渡す)
          hash[:rule] = params[:rule] || ""
          hash[:xmode] = params[:xmode] || ""

          hash[:user] = { key: user.key }

          hash[:rules_hash] = rules_hash

          # トータル勝敗数
          hash[:judge_counts] = judge_counts

          # 直近勝敗リスト
          hash[:judge_keys] = current_scope.limit(current_ox_max).s_pluck_judge_key.reverse # limitは上書きできる

          hash[:medal_list] = medal_list.to_a

          if Rails.env.development?
            hash[:debug_hash] = medal_list.to_debug_hash
            hash[:win_lose_streak_max_hash] = medal_list.win_lose_streak_max_hash
          end

          ################################################################################

          hash[:every_day_list]       = every_day_list
          hash[:every_grade_list]     = every_grade_list
          hash[:every_my_attack_list] = every_my_attack_list
          hash[:every_vs_attack_list] = every_vs_attack_list
          hash[:every_my_defense_list] = every_my_defense_list
          hash[:every_vs_defense_list] = every_vs_defense_list
          hash[:etc_list] = etc_list
        end
      end

      def judge_counts
        @judge_counts ||= judge_counts_wrap(ids_scope.s_group_judge_key.count)
      end

      def medal_list
        @medal_list ||= MedalList.new(self)
      end

      def current_scope
        s = user.memberships
        s = win_lose_only_condition_add(s)
      end

      # all_tag_counts を使う場合 current_scope の条件で引いたもので id だけを取得してSQLを作り直した方が若干速い
      # また group するときも order が入っていると MySQL では group に order のカラムも含めないと、
      # 正しく動かなくてわけわからんんことになるのでそれの回避
      def ids_scope
        Membership.where(id: current_scope.ids) # 再スコープ化
      end

      def win_scope
        @win_scope ||= ids_scope.s_where_judge_key_eq("win")
      end

      def win_count
        @win_count ||= win_scope.count
      end

      def lose_scope
        @lose_scope ||= ids_scope.s_where_judge_key_eq("lose")
      end

      def lose_count
        @lose_count ||= lose_scope.count
      end

      # 最低でも2以上にすること
      def turn_max_gteq
        50
      end

      def real_count
        @real_count ||= current_scope.count
      end

      def at_least_value
        # 1だったら指定しなくていいんじゃね？
        # 1
      end

      def sample_max
        @sample_max ||= yield_self do
          v = params[:sample_max].presence || default_params[:sample_max]
          [v.to_i, max_of_max].min
        end
      end

      # 対段級
      def every_grade_list
        s = user.op_memberships
        s = win_lose_only_condition_add(s)
        denominator = s.count

        s = Membership.where(id: s.ids) # 再スコープ化

        s = s.joins(:grade).group(Grade.arel_table[:key]) # 段級と
        s = s.joins(:judge).group(Judge.arel_table[:key])        # 勝ち負けでグループ化
        s = s.order(Grade.arel_table[:priority])          # 相手が強い順
        hash = s.count                                           # => {["九段", "lose"]=>2, ["九段", "win"]=>1, ["初段", "lose"]=>1}

        counts = {}
        hash.each do |(grade_key, judge_key), count|
          counts[grade_key] ||= { win: 0, lose: 0 }
          judge_info = JudgeInfo.fetch(judge_key)
          counts[grade_key][judge_info.flip.key] = count # 勝敗反転
        end

        counts # => {"九段"=>{:win=>2, :lose=>1}, "初段"=>{:win=>1, :lose=>0}}

        ary = counts.collect do |k, v|
          total = v.sum { |_, c| c } # total = v[:win] + v[:lose]
          { grade_name: k, judge_counts: v, appear_ratio: total.fdiv(denominator) }
        end

        ary # => [{:grade_name=>"九段", :judge_counts=>{:win=>2, :lose=>1}}, {:grade_name=>"初段", :judge_counts=>{:win=>1, :lose=>0}}]
      end

      def win_lose_only_condition_add(s)
        s = condition_add(s)
        s = s.merge(Battle.win_lose_only) # 勝敗が必ずあるもの
      end

      # 必須の条件
      def condition_add(s)
        s = s.joins(:battle)
        s = s.merge(Battle.newest_order)  # 直近のものから取得
        if v = params[:rule].presence
          s = s.merge(Battle.rule_eq(v))
        end
        if v = params[:xmode].presence
          s = s.merge(Battle.xmode_eq(v))
        end
        s = s.limit(sample_max)
        s
      end

      # all_tag_names_hash_or_zero("居飛車")         # => 1
      # all_tag_names_hash_or_zero("存在しない戦法") # => 0
      def all_tag_names_hash_or_zero(key)
        all_tag_names_hash[key.to_s] || 0
      end

      # all_tag_names_hash["居飛車"]         # => 1
      # all_tag_names_hash["存在しない戦法"] # => nil
      def all_tag_names_hash
        @all_tag_names_hash ||= yield_self do
          counts = ids_scope.all_tag_counts(at_least: at_least_value)
          counts.inject({}) { |a, e| a.merge(e.name => e.count) }
        end
      end

      # 棋神
      # turn_max >= 2 なら obt_think_avg と think_end_avg は nil ではないので turn_max >= 2 の条件を必ず入れること
      #
      #   SELECT swars_memberships.* FROM swars_memberships
      #     INNER JOIN swars_battles ON swars_battles.id = swars_memberships.battle_id
      #     INNER JOIN swars_grades  ON swars_grades.id  = swars_memberships.grade_id
      #     WHERE
      #           swars_memberships.id = 13
      #       AND swars_memberships.judge_key = 'win'
      #       AND swars_battles.turn_max >= 50
      #       AND swars_memberships.obt_auto_max >= 10
      #       AND ((swars_battles.rule_key = 'ten_min' OR swars_battles.rule_key = 'ten_sec') OR swars_grades.priority <= 5)
      #
      def ai_use_battle_count_lv1
        @ai_use_battle_count_lv1 ||= yield_self do
          # A
          s = win_scope                                                                           # 勝っている
          s = s.joins(:battle, :grade)
          s = s.where(Membership.arel_table[:grade_diff].gteq(0)) if false                 # 自分と同じか格上に対して
          # s = s.where(Battle.arel_table[:final_key].eq_any(["TORYO", "TIMEOUT", "CHECKMATE"])) # もともと CHECKMATE だけだったが……いらない？
          s = s.where(Battle.arel_table[:turn_max].gteq(turn_max_gteq))                    # 50手以上の対局で
          s = s.where(Membership.arel_table[:obt_auto_max].gteq(AiCop.obt_auto_max_gteq))

          # if MembershipMedalInfo::AI_JUDGMENT_EXCLUDE_THREE_MIN
          #   s = s.where(Battle.arel_table[:rule_key].not_eq(:three_min))                     # 3分は除く
          # end

          c1 = Battle.joins(:rule).where(Rule.arel_table[:key].eq_any([:ten_min, :ten_sec]))  # 10分 or 10秒
          c2 = Grade.unscoped.where(Grade.arel_table[:priority].between(Grade.god_priority_range)) # or 対象段位

          # s and (c1 or c2)
          # ((swars_battles.rule_key = 'ten_min' OR swars_battles.rule_key = 'ten_sec') OR swars_grades.priority <= 5)
          s = s.merge(c1.or(c2))

          # if false
          #   # (B or C)
          #   a = Membership.where(Membership.arel_table[:obt_think_avg].lteq(3))       # 指し手平均3秒以下
          #   a = a.or(Membership.where(Membership.arel_table[:think_end_avg].lteq(2))) # または最後の5手の平均指し手が2秒以下
          #
          #   # A and (B or C)
          #   s = s.merge(a)
          # else

          # c1 = Membership.where(Membership.arel_table[:obt_think_avg].lteq(1))
          # c2 = Membership.where(Membership.arel_table[:obt_auto_max].gteq(10))
          # c2 = Membership.where(Membership.arel_table[:obt_auto_max].gteq(AiCop.obt_auto_max_gteq))
          # s = s.merge(c1.or(c2))

          # end

          # c1 = Membership.where(Membership.arel_table[:two_serial_max].gteq(10))
          # c2 = Membership.where(Membership.arel_table[:two_serial_max].gteq(5))
          # c3 = Membership.where(Membership.arel_table[:think_end_avg].lteq(2))
          # c4 = c1.or(c2.merge(c3))     # c1 or c2 and c3 は c1 or (c2 and c3) のこと
          # s = s.merge(c4)

          s.count
        end
      end

      # def ai_use_battle_count_lv2
      #   @ai_use_battle_count_lv2 ||= yield_self do
      #     s = win_scope
      #     s = s.joins(:battle)
      #     s = s.where(Battle.arel_table[:turn_max].gteq(turn_max_gteq))
      #     if MembershipMedalInfo::AI_JUDGMENT_EXCLUDE_THREE_MIN
      #       s = s.where(Battle.arel_table[:rule_key].not_eq(:three_min))                      # 3分は除く
      #     end
      #     # c1 = Membership.where(Membership.arel_table[:obt_think_avg].lteq(1))
      #     c2 = Membership.where(Membership.arel_table[:obt_auto_max].gteq(AiCop.obt_auto_max_gteq))
      #     # s = s.merge(c1.or(c2))
      #     s = s.merge(c2)
      #     s.count
      #   }.call
      # end

      ################################################################################

      def etc_list
        list = [

          ################################################################################
          { name: "切断逃亡",                            type1: "simple", type2: "numeric_with_unit", unit: "回", body: disconnect_count,              },
          { name: "角不成",                              type1: "simple", type2: "numeric_with_unit", unit: "回", body: kakuhunari_count,              },
          { name: "飛車不成",                            type1: "simple", type2: "numeric_with_unit", unit: "回", body: hisyahunari_count,              },

          ################################################################################

          { name: "派閥",       type1: "pie",             type2: nil, body: formation_info_records, pie_type: "is_many_values" },
          { name: "戦法スタイル", type1: "pie",             type2: nil, body: rarity_ratio.to_chart,      pie_type: "is_many_values" },
          { name: "居飛車",     type1: "win_lose_circle", type2: nil, body: ibisha_note_judge_info.to_chart,     win_lose_click_method_name: "ibisha_win_lose_click_handle", },
          { name: "振り飛車",   type1: "win_lose_circle", type2: nil, body: furibisha_note_judge_info.to_chart,  win_lose_click_method_name: "furibisha_win_lose_click_handle", },

          ################################################################################

          { name: "対局モード",                          type1: "pie",    type2: nil,                             body: xmode_info_records,           pie_type: "is_many_values" },

          ################################################################################
          { name: "勝敗別平均手数",                      type1: "pie",    type2: nil,                             body: avg_win_lose_turn_max,        pie_type: "is_many_values" },
          { name: "平均手数",                            type1: "simple", type2: "numeric_with_unit", unit: "手", body: avg_of_turn_max,               },
          { name: "投了時の平均手数",                    type1: "simple", type2: "numeric_with_unit", unit: "手", body: avg_of_toryo_turn_max,         },

          ################################################################################

          { name: "投了せずに放置した頻度",              type1: "pie",    type2: nil,                             body: count_of_timeout_think_last,   pie_type: "is_many_values" },
          { name: "投了せずに放置した時間の最長",        type1: "simple", type2: "second",                        body: max_of_timeout_think_last,     },

          ################################################################################

          { name: "1日の平均対局数",                     type1: "simple", type2: "numeric_with_unit", unit: "局", body: avg_of_avg_battles_count_per_day,              },
          { name: "対局時間帯",                          type1: "bar",    type2: nil,                             body: battle_count_per_hour_records.to_chart,  bar_type: "is_default", },

          ################################################################################

          ################################################################################
          { name: "勝ち",                                type1: "pie",    type2: nil,                             body: judge_info_records(:win),      pie_type: "is_many_values" },
          # { name: "棋神乱用の疑い",                      type1: "pie",    type2: nil,                             body: kishin_info_records_lv2,       pie_type: "is_pair_values" },
          { name: "1手詰を焦らして悦に入った頻度",       type1: "pie",   type2:  nil,                             body: count_of_checkmate_think_last, pie_type: "is_many_values" },
          { name: "1手詰を焦らして悦に入った時間(最長)", type1: "simple", type2: "second",                        body: max_of_checkmate_think_last,   },

          ################################################################################
          { name: "負け",                                type1: "pie",    type2: nil,                             body: judge_info_records(:lose),     pie_type: "is_many_values" },
          { name: "投了までの心の準備",                  type1: "pie",    type2: nil,                             body: count_of_toryo_think_last,   pie_type: "is_many_values" },
          { name: "投了までの心の準備(平均)",            type1: "simple", type2: "second",                        body: avg_of_toryo_think_last,     },
          { name: "投了までの心の準備(最長)",            type1: "simple", type2: "second",                        body: max_of_toryo_think_last,     },

          ################################################################################
          { name: "最大思考",                            type1: "simple", type2: "second",                        body: max_of_think_max,              },
          { name: "平均思考",                            type1: "simple", type2: "second",                        body: avg_of_think_all_avg,          },
          { name: "詰ます速度(1手平均)",                 type1: "simple", type2: "second",                        body: avg_of_think_end_avg,          },

          ################################################################################

          { name: "駒の使用率",                        type1: "bar",    type2: nil,                             body: used_piece_counts_records.to_chart, bar_type: "is_default", tategaki_p: true, value_format: "percentage", },

          ################################################################################
          { name: "対戦相手との段級差(平均)",           type1: "simple", type2: "raw",                           body: avg_of_grade_diff,             },

          ################################################################################

          { name: "右玉度",                              type1: "pie",    type2: nil,                             body: migigyoku_levels,                     pie_type: "is_pair_values" },
          { name: "右玉ファミリー",                      type1: "pie",    type2: nil,                             body: migigyoku_kinds,                    pie_type: "is_many_values" },

          ################################################################################
          { name: "将棋ウォーズの運営を支える力",        type1: "pie",    type2: nil,                            body: kishin_info_records,           pie_type: "is_pair_values" },
        ]
        if Rails.env.development?
          list.unshift({
              name: "テスト",
              type1: "pie",
              type2: nil,
              body: [
                { name: "a", value: 1 },
                { name: "b", value: 2 },
                { name: "c", value: 3 },
                { name: "d", value: 4 },
                { name: "e", value: 5 },
              ],
              pie_type: "is_many_values",
            })
        end
        list
      end

      def judge_info_records(judge_key)
        s = ids_scope
        s = s.s_where_judge_key_eq(judge_key)

        s = s.joins(:battle => :final)
        s = s.group(Final.arel_table[:key])

        if JUDGE_INFO_RECORDS_INCLUDE_EMPTY_LABEL
        else
          s = s.order("count_all DESC")
        end
        counts_hash = s.count # { TORYO: 3, CHECKMATE: 1 }

        if counts_hash.present?
          if JUDGE_INFO_RECORDS_INCLUDE_EMPTY_LABEL
            counts_hash = counts_hash.symbolize_keys
            h = {}
            FinalInfo.each do |e|
              if v = counts_hash[e.key]
                h[e.key] = v
              else
                if e.chart_required
                  h[e.key] = 0
                end
              end
            end
          else
            h = counts_hash
          end

          h.collect do |key, value|
            final_info = FinalInfo.fetch(key)
            {
              :key   => key,
              # :name  => final_info.name2(judge_key),
              :name  => final_info.name,
              :value => value,
            }
          end
        end
      end

      def formation_info_records
        records = ["居飛車", "振り飛車"].collect do |e|
          { name: e, value: all_tag_names_hash_or_zero(e) }
        end
        if records.any? { |e| e[:value] > 0 }
          records
        end
      end

      def xmode_info_records
        if (xmode_counts["友達"] + xmode_counts["指導"]) > 0
          XmodeInfo.collect do |e|
            { name: e.name, value: xmode_counts[e.key.to_s] }
          end
        end
      end

      def kishin_info_records
        if v = ai_use_battle_count_lv1
          if v.positive?
            [
              { name: "有り", value: ai_use_battle_count_lv1,             },
              { name: "無し", value: win_count - ai_use_battle_count_lv1, },
            ]
          end
        end
      end

      # def kishin_info_records_lv2
      #   if v = ai_use_battle_count_lv2
      #     if v.positive?
      #       [
      #         { name: "有り", value: v,             },
      #         { name: "無し", value: win_count - v, },
      #       ]
      #     end
      #   end
      # end

      ################################################################################

      def max_of_think_max
        ids_scope.maximum(:think_max)
      end

      def avg_of_think_all_avg
        if v = ids_scope.average(:think_all_avg)
          v.to_f.round(2)
        end
      end

      def avg_of_turn_max
        if false
          s = Battle.where(id: current_scope.pluck(:battle_id))
          if v = s.average(:turn_max)
            v.to_i
          end
        else
          s = ids_scope
          s = s.joins(:battle)
          if v = s.average(Battle.arel_table[:turn_max])
            v.to_i
          end
        end
      end

      def avg_of_grade_diff
        if v = current_scope.average(:grade_diff) # FIXME: 恐怖の級位者がいるので6以上離れていたら除外した方がいい
          v.to_f.round(2)
        end
      end

      ################################################################################

      def timeout_think_last_scope
        s = lose_scope
        s = s.joins(:battle => :final)
        s = s.where(Battle.arel_table[:turn_max].gteq(14))
        s = s.where(Final.arel_table[:key].eq("TIMEOUT"))
        s = s.where(Membership.arel_table[:think_last].gteq(60))
      end

      def count_of_timeout_think_last
        s = timeout_think_last_scope
        # s = ids_scope
        h = s.group("think_last DIV 60").order("count_all desc").count
        if h.present?
          h.collect do |min, count|
            { name: "#{min}分", value: count }
          end
        end
      end

      def max_of_timeout_think_last
        if v = timeout_think_last_scope.maximum(:think_last)
          v
        end
      end

      ################################################################################

      def toryo_think_last_scope0
        return ids_scope

        s = lose_scope
        s = s.joins(:battle => :final)
        s = s.where(Battle.arel_table[:turn_max].gteq(14))
        s = s.where(Final.arel_table[:key].eq("TORYO"))
      end

      def count_of_toryo_think_last
        sep_min = 1.minutes
        sep_sec = 10.seconds
        list = []

        # 1分未満は10分割
        s = toryo_think_last_scope0
        s = s.where(Membership.arel_table[:think_last].lt(sep_min))
        h = s.group("think_last DIV #{sep_sec}").order("count_all desc").count
        if h.present?
          list += h.collect do |quotient, count|
            if quotient.zero?
              name = "#{sep_sec}秒未満"
            else
              name = "#{quotient * sep_sec}秒"
            end
            { name: name, value: count }
          end
        end

        # 1分以上
        s = toryo_think_last_scope0
        s = s.where(Membership.arel_table[:think_last].gteq(sep_min))
        h = s.group("think_last DIV #{sep_min}").order("count_all desc").count
        if h.present?
          list += h.collect do |quotient, count|
            { name: "#{quotient}分", value: count }
          end
        end

        list
      end

      def max_of_toryo_think_last
        if v = toryo_think_last_scope0.maximum(:think_last)
          v
        end
      end

      def avg_of_toryo_think_last
        if v = toryo_think_last_scope0.average(:think_last)
          v.to_f.round(2)
        end
      end

      ################################################################################

      def checkmate_think_last_gteq
        30
      end

      def checkmate_think_last_scope
        s = win_scope
        s = s.where(Membership.arel_table[:think_last].gteq(checkmate_think_last_gteq))
        s = s.joins(:battle => :final)
        s = s.where(Final.arel_table[:key].eq("CHECKMATE"))
        # s = s.where(Battle.arel_table[:turn_max].gteq(14))
      end

      def count_of_checkmate_think_last
        # if v = checkmate_think_last_scope.count
        #   if v.positive?
        #     v
        #   end
        # end

        s = checkmate_think_last_scope
        # s = ids_scope
        h = s.group("think_last DIV 60").order("count_all desc").count
        if h.present?
          h.collect do |min, count|
            if min.zero?
              min = "#{checkmate_think_last_gteq}秒"
            else
              min = "#{min}分"
            end
            { name: min, value: count }
          end
        end
      end

      def max_of_checkmate_think_last
        if v = checkmate_think_last_scope.maximum(:think_last)
          v
        end
      end

      ################################################################################

      def disconnect_count
        s = lose_scope
        s = s.joins(:battle => :final)
        s = s.where(Battle.arel_table[:turn_max].gteq(14))
        s = s.where(Final.arel_table[:key].eq("DISCONNECT"))
        if v = s.count
          if v.positive?
            v
          end
        end
      end

      ################################################################################

      def kakuhunari_count
        all_tag_names_hash["角不成"]
      end

      def hisyahunari_count
        all_tag_names_hash["飛車不成"]
      end

      ################################################################################

      # SELECT AVG(swars_battles.turn_max) FROM swars_memberships INNER JOIN swars_battles ON swars_battles.id = swars_memberships.battle_id WHERE swars_memberships.id IN (92, 93, 96, 97, 100, 101, 103, 105, 107, 110) AND swars_memberships.judge_key = 'lose' AND swars_battles.final_key = 'TORYO'
      def avg_of_toryo_turn_max
        s = lose_scope
        s = s.joins(:battle => :final)
        s = s.where(Final.arel_table[:key].eq("TORYO"))
        if v = s.average(Battle.arel_table[:turn_max])
          v.to_i
        end
      end

      ################################################################################

      def avg_of_think_end_avg
        s = win_scope
        s = s.joins(:battle => :final)
        s = s.where(Final.arel_table[:key].eq("CHECKMATE"))
        if v = s.average(:think_end_avg)
          v.to_f.round(2)
        end
      end

      ################################################################################

      def avg_win_lose_turn_max
        records = [:win, :lose].collect do |key|
          info = JudgeInfo.fetch(key)
          { name: info.name, value: avg_turn_max_for(key) || 0 }
        end
        if records.any? { |e| e[:value] > 0 }
          records
        end
      end

      def avg_turn_max_for(judge_key)
        s = ids_scope.s_where_judge_key_eq(judge_key)
        s = s.joins(:battle => :final)
        s = s.where(Final.arel_table[:key].eq_any(["TORYO", "TIMEOUT", "CHECKMATE"]))
        if v = s.average(:turn_max)
          v.to_i
        end
      end

      ################################################################################

      def migigyoku_levels
        total = Bioshogi::Explain::GroupInfo.fetch("右玉").values.sum { |e| all_tag_names_hash_or_zero(e) }
        if total.positive?
          [
            { name: "右玉",   value: total              },
            { name: "その他", value: real_count - total },
          ]
        end
      end

      def migigyoku_kinds
        list = Bioshogi::Explain::GroupInfo.fetch("右玉").values.find_all { |e| all_tag_names_hash_or_zero(e).positive? }
        if list.present?
          list.collect { |e|
            { name: e, value: all_tag_names_hash_or_zero(e) }
          }.sort_by { |e| -e[:value] }
        end
      end

      ################################################################################

      # 1日の平均対局数
      def avg_of_avg_battles_count_per_day
        battle_ids = ids_scope.pluck(:battle_id)
        # battle_ids = []
        if battle_ids.present?
          # まず日別の対局数を求める
          sql = <<~EOT
            SELECT DATE(#{MysqlUtil.column_tokyo_timezone_cast('battled_at')}) AS battled_on, COUNT(*) AS count_all
            FROM swars_battles
            WHERE id IN (#{battle_ids.join(', ')})
            GROUP BY battled_on
        EOT
          Rails.logger.debug { ActiveRecord::Base.connection.select_all(sql).to_a.to_t }
          # |------------+-----------|
          # | battled_on | count_all |
          # |------------+-----------|
          # | 2021-05-18 |         3 |
          # | 2021-05-19 |         1 |
          # | 2021-05-20 |         2 |
          # |------------+-----------|
          # count_all の値たちの平均を求める
          sql = "SELECT AVG(count_all) FROM (#{sql}) as grouping" # (3 + 1 + 2) / 3 => 2
          ActiveRecord::Base.connection.select_value(sql).to_f.round(2)
        end
      end

      def battle_count_per_hour_records
        @battle_count_per_hour_records ||= BattleCountPerHourRecords.new(self)
      end

      def used_piece_counts_records
        @used_piece_counts_records ||= UsedPieceCountsRecords.new(self)
      end

      # 対局モードの個数
      # {"通常"=>1, "友達"=>0, "指導"=>0}
      def xmode_counts
        @xmode_counts ||= yield_self do
          s = user.memberships
          s = condition_add(s)
          s = Battle.where(id: s.pluck(:battle_id))
          s = s.group(:xmode_id)
          c = s.count
          Xmode.all.inject({}) do |a, e|
            a.merge(e.key => c[e.id] || 0)
          end
        end
      end

      # 戦法スタイル
      def rarity_ratio
        @rarity_ratio ||= RarityRatio.new(self)
      end

      def ibisha_note_judge_info
        @ibisha_note_judge_info ||= NoteJudgeInfo.new(self, "居飛車")
      end

      def furibisha_note_judge_info
        @furibisha_note_judge_info ||= NoteJudgeInfo.new(self, "振り飛車")
      end

      private

      def current_ox_max
        [(params[:ox_max].presence || default_params[:ox_max]).to_i, 100].min
      end

      # memberships が配列になっているとき用
      def judge_counts_of(memberships)
        group = memberships.group_by(&:judge_key)
        ["win", "lose"].inject({}) { |a, e| a.merge(e => (group[e] || []).count) }
      end

      def rules_hash
        group = current_scope.includes(:battle).group_by { |e| e.battle.rule_key }

        RuleInfo.inject({}) do |a, e|
          hash = {}
          hash[:rule_name] = e.name
          if membership = (group[e.key.to_s] || []).first
            hash[:grade_name] = membership.grade.name # grade へのアクセスはここだけなので includes しない方がよい
          else
            hash[:grade_name] = nil
          end
          a.merge(e.key => hash)
        end
      end

      def every_day_list
        group = current_scope.includes(:battle).group_by { |e| e.battle.battled_at.midnight }
        group.collect do |battled_at, memberships|

          hash = {}
          hash[:battled_on]   = battled_at.to_date
          hash[:day_type]    = day_type_for(battled_at)
          hash[:judge_counts] = judge_counts_of(memberships)
          hash[:all_tags] = nil   # ← 設定すればビュー側で出る

          s = Membership.where(id: memberships.collect(&:id)) # 再スコープ化

          # 戦法と囲いをまぜて一番使われている順にN個表示する場合
          if false
            tags = [:attack_tags, :defense_tags].flat_map do |tags_method|
              s.tag_counts_on(tags_method, at_least: at_least_value, order: "count desc")
            end
            tags = tags.sort_by { |e| -e.count }
            hash[:all_tags] = tags.take(2).collect { |e| e.attributes.slice("name", "count") }
          end

          # 戦法と囲いそれぞれ一番使われているもの1個ずつ計2個
          if false
            hash[:all_tags] = [:attack_tags, :defense_tags].flat_map { |tags_method|
              s.tag_counts_on(tags_method, at_least: at_least_value, order: "count desc", limit: 1)
            }.collect{ |e| e.attributes.slice("name", "count") }
          end

          hash
        end
      end

      # 戦法 * 自分
      def every_my_attack_list
        list_build(user.memberships, context: :attack_tags, judge_flip: false)
      end

      # 戦法 * 相手
      def every_vs_attack_list
        list_build(user.op_memberships, context: :attack_tags, judge_flip: true)
      end

      # 囲い * 自分
      def every_my_defense_list
        list_build(user.memberships, context: :defense_tags, judge_flip: false)
      end

      # 囲い * 相手
      def every_vs_defense_list
        list_build(user.op_memberships, context: :defense_tags, judge_flip: true)
      end

      def list_build(memberships, options = {})
        s = memberships
        s = win_lose_only_condition_add(s)
        denominator = s.count

        # tag_counts_on をシンプルなSQLで実行させると若干速くなるが、それのためではなく
        # sample_max 件で最初に絞らないといけない
        s = Membership.where(id: s.ids) # 再スコープ化

        tags = s.tag_counts_on(options[:context], at_least: at_least_value, order: "count desc") # FIXME: tag_counts_on.group("name").group("judge_key") のようにできるはず
        tags.collect do |tag|
          {}.tap do |hash|
            hash[:tag] = tag.attributes.slice("name", "count")  # 戦法名
            hash[:appear_ratio] = tag.count.fdiv(denominator)         # 使用頻度, 遭遇率

            # 勝ち負け数
            c = judge_counts_wrap(s.tagged_with(tag.name, on: options[:context]).s_group_judge_key.count) # => {"win" => 1, "lose" => 0}
            if options[:judge_flip]
              c["win"], c["lose"] = c["lose"], c["win"] # => {"win" => 0, "lose" => 1}    ; 自分視点に変更
            end
            hash[:judge_counts] = c
          end
        end
      end

      # judge_counts_wrap({})         # => {"win" => 0, "lose" => 0}
      # judge_counts_wrap("win" => 1) # => {"win" => 1, "lose" => 0}
      def judge_counts_wrap(hash)
        {"win" => 0, "lose" => 0}.merge(hash) # JudgeInfo.inject({}) { |a, e| a.merge(e.key.to_s => 0) }.merge(hash)
      end

      def day_type_for(t)
        case
        when t.sunday?
          :danger
        when t.saturday?
          :info
        when HolidayJp.holiday?(t)
          :danger
        end
      end
    end
  end
end
