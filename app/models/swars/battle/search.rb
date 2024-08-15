# frozen-string-literal: true

module Swars
  class Battle
    class Search
      CONDITION_PATTERN0 = [
        { db_column: :id,    query_key: ["id", "ids"],                                         },
        { db_column: :key,   query_key: ["key", "keys"],                                       },
      ]

      CONDITION_PATTERN1 = [
        { belongs_to: :xmode,  query_key: ["xmode", "モード", "対局モード"],                    },
        { belongs_to: :rule,   query_key: ["rule", "持ち時間", "種類"],                         },
        { belongs_to: :final,  query_key: ["final", "結末", "最後"],                            },
        { belongs_to: :preset, query_key: ["preset", "手合割", "手合"],                         },
      ]

      CONDITION_PATTERN2 = [
        { db_column: :critical_turn, query_key: ["critical_turn", "開戦"],                     },
        { db_column: :outbreak_turn, query_key: ["outbreak_turn", "中盤"],                     },
        { db_column: :turn_max,      query_key: ["turn_max", "手数"],                          },
      ]

      CONDITION_PATTERN3 = [
        { target: :my, belongs_to: :judge,    query_key: ["judge",    "勝敗"],                 },
        { target: :my, belongs_to: :location, query_key: ["location", "先後"],                 },
        { target: :my, belongs_to: :style,    query_key: ["style",    "自分の棋風", "棋風"],   },
        { target: :my, belongs_to: :grade,    query_key: ["grade",    "自分の棋力", "棋力"],   },
        { target: :op, belongs_to: :style,    query_key: ["vs-style", "相手の棋風"],           },
        { target: :op, belongs_to: :grade,    query_key: ["vs-grade", "相手の棋力"],           },
      ]

      CONDITION_PATTERN4 = [
        { target: :my, query_key: ["tag"],                       tagged_with_options: {                    }, },
        { target: :my, query_key: ["or-tag", "any-tag"],         tagged_with_options: { any: true          }, },
        { target: :my, query_key: ["-tag", "exclude-tag"],       tagged_with_options: { exclude: true      }, },
        { target: :op, query_key: ["vs-tag"],                    tagged_with_options: {                    }, },
        { target: :op, query_key: ["vs-or-tag", "vs-any-tag"],   tagged_with_options: { any: true          }, },
        { target: :op, query_key: ["-vs-tag", "vs-exclude-tag"], tagged_with_options: { exclude: true      }, },
      ]

      CONDITION_MEMBERSHIP_INTEGER = [
        { db_column: :think_max,     query_key: ["think_max", "最大思考"],                     },
        { db_column: :think_last,    query_key: ["think_last", "最終思考"],                    },
        { db_column: :think_all_avg, query_key: ["think_all_avg", "平均思考"],                 },
        { db_column: :ai_wave_count, query_key: ["ai_wave_count", "棋神波形数"],               },
        { db_column: :ai_drop_total, query_key: ["ai_drop_total", "棋神を模倣した指し手の数"], },
        { db_column: :grade_diff,    query_key: ["vs-grade-diff", "力差", "棋力差", "段級差"], },
      ]

      # RELATED_TABLES_TO_BE_RETRIEVED_AT_ONCE = {
      #   :win_user => nil,
      #   :xmode    => nil,
      #   :rule     => nil,
      #   :final    => nil,
      #   :preset   => nil,
      #   :memberships => {
      #     :user     => :profile,
      #     :grade    => nil,
      #     :location => nil,
      #     :style    => nil,
      #     :judge    => nil,
      #     :taggings => :tag,
      #   },
      # }

      # 単に ids を求めるのに includes すると50倍遅くなるため includes はオプションにすること
      # _ { s.includes(r).ids }         # => "267.59 ms"
      # _ { s.ids }                     # => "6.01 ms"
      RELATED_TABLES_TO_BE_RETRIEVED_AT_ONCE = [
        :win_user,
        :xmode,
        :rule,
        :final,
        :preset,
        {
          :memberships => [
            [
              :grade,
              :location,
              :style,
              :judge,
            ],
            {
              :user => :profile,
              :taggings => :tag,
            },
          ],
        }
      ]

      attr_reader :params

      def initialize(params = {})
        @params = {
          :target_owner  => nil,   # 自分側とするユーザー (optional だが memberships を参照する検索の場合には必須とする)
          :with_includes => false, # ids がほしいだけの場合に、includes してはいけない。50倍遅くなる。
        }.merge(params)
      end

      def call
        @scope = params[:all]
        case_CONDITION_PATTERN0 # id, key
        case_CONDITION_PATTERN1 # xmode
        case_CONDITION_PATTERN2 # turn_max
        case_CONDITION_PATTERN3 # membership - judge
        case_CONDITION_MEMBERSHIP_TAG # membership - tag
        case_CONDITION_MEMBERSHIP_INTEGER # membership - think_max
        case_battled_at_range
        case_account_ban
        case_versus
        process_with_includes
        @scope
      end

      private

      ################################################################################

      def case_CONDITION_PATTERN0
        CONDITION_PATTERN0.each do |e|
          if values = qi.lookup_first(e[:query_key])
            @scope = @scope.where(e[:db_column] => values.collect(&:to_s))
          end
        end
      end

      def case_battled_at_range
        if date_strs = qi.lookup_first(["date", "日付", "日時"])
          date_strs.each do |date_str|
            if date_range = DateRange.parse(date_str)
              @scope = @scope.where(battled_at: date_range)
            end
          end
        end
      end

      def case_CONDITION_PATTERN1
        CONDITION_PATTERN1.each do |e|
          if values = qi.lookup_first(e[:query_key])
            @scope = @scope.public_send("#{e[:belongs_to]}_ex", values)
          end
        end
      end

      def case_CONDITION_PATTERN2
        CONDITION_PATTERN2.each do |e|
          if operations = qi.lookup_first(e[:query_key])
            column = Battle.arel_table[e[:db_column]]
            operations.each do |opration|
              unless opration.kind_of?(Hash)
                if Rails.env.local?
                  value = opration
                  raise "条件の書き方が間違っている : #{e[:db_column]}:#{value} ではなく #{e[:db_column]}:==#{value} と書け"
                end
                next
              end
              condition = column.public_send(opration[:operator], opration[:value])
              @scope = @scope.where(condition) # where(arel_table[:xxx].gteq(1))
            end
          end
        end
      end

      def case_CONDITION_PATTERN3
        CONDITION_PATTERN3.each do |e|
          if values = qi.lookup_first(e[:query_key]) # values = qi.lookup_first("judge", "勝敗")
            filter_by send(e[:target]).public_send("#{e[:belongs_to]}_ex", values) # m = my.judge_ex(values)
          end
        end
      end

      def case_CONDITION_MEMBERSHIP_TAG
        CONDITION_PATTERN4.each do |e|
          if tag_names = qi.lookup_first(e[:query_key])
            filter_by send(e[:target]).tagged_with(tag_names, e[:tagged_with_options]) # タグ検索は複数のタグをまとめて指定できる
          end
        end
      end

      def case_CONDITION_MEMBERSHIP_INTEGER
        CONDITION_MEMBERSHIP_INTEGER.each do |e|
          if operations = qi.lookup_first(e[:query_key])
            column = Membership.arel_table[e[:db_column]]
            operations.each do |e|
              condition = column.public_send(e[:operator], e[:value])
              filter_by my.where(condition)
            end
          end
        end
      end

      # ON / OFF の二択なので av.sole にしていたがなるべくエラーを出したくないのですべて条件に指定する
      def case_account_ban
        if values = qi.lookup_first(["垢BAN", "BAN"])
          baned_users = target_owner.op_users.ban_only # 「相手が」BANかどうかを知りたい。
          # target_owner.op_users は target_owner.memberships.collect(&:op_user) をDBで引いたものなので充分速い。
          values.each do |value|
            ban_info = BanInfo.fetch(value)
            if ban_info == BanInfo.fetch(:and)
              filter_by op.where(user: baned_users)
            else
              filter_by op.where.not(user: baned_users)
            end
          end
        end
      end

      def case_versus
        if swars_user_keys = qi.lookup_first(["vs", "相手", "対戦相手"])
          users = User.where(user_key: swars_user_keys)
          filter_by op.where(user: users)
        end
      end

      def process_with_includes
        if @params[:with_includes]
          @scope = @scope.includes(RELATED_TABLES_TO_BE_RETRIEVED_AT_ONCE)
        end
      end

      ################################################################################

      def query_info
        @query_info ||= params[:query_info] || query_str_to_query_info || QueryInfo.null
      end

      def qi
        query_info
      end

      def my
        @my ||= target_owner.memberships
      end

      def op
        @op ||= target_owner.op_memberships
      end

      def target_owner
        @target_owner ||= params[:target_owner].tap do |user_object|
          unless user_object
            raise ArgumentError, "対局データのなかから対局者の情報を引く場合は、どちらが当事者なのか params[:target_owner] で明示してください"
          end
        end
      end

      def filter_by(memberships)
        @scope = @scope.where(id: memberships.pluck(:battle_id))
      end

      def query_str_to_query_info
        if s = params[:query]
          QueryInfo.parse(s)
        end
      end
    end
  end
end
