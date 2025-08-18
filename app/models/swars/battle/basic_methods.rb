module Swars
  class Battle
    concern :BasicMethods do
      class_methods do
        def [](key)
          find_by(key: key)
        end

        def create_with_members!(users, attributes = {})
          create!(attributes) do |e|
            users.each do |user|
              e.memberships.build(user: user)
            end
          end
        end
      end

      included do
        OLD_CSA_SEQ = [["+7968GI", 599], ["-8232HI", 597], ["+5756FU", 594], ["-3334FU", 590], ["+6857GI", 592]]

        belongs_to :win_user, class_name: "Swars::User", optional: true # 勝者プレイヤーへのショートカット。引き分けの場合は入っていない。memberships.win.user と同じ

        has_many :memberships, -> { order(:position) }, dependent: :destroy, inverse_of: :battle do
          def black
            self[Bioshogi::Location[:black].code]
          end

          def white
            self[Bioshogi::Location[:white].code]
          end
        end

        has_many :users, through: :memberships

        scope :win_lose_only, -> { where.not(win_user_id: nil) } # 勝敗が必ずあるもの
        scope :draw_only,     -> { where(win_user_id: nil) }     # 引き分けのもの
        scope :latest_order, -> { order(battled_at: :desc) }     # 新しい順
        scope :valid_match_only, -> { where(arel_table[:turn_max].gteq(Config.seiritsu_gteq)) } # 成立していると見なす対局に絞る

        custom_belongs_to :rule,  ar_model: Rule,  st_model: RuleInfo,  default: "10分"
        custom_belongs_to :final, ar_model: Final, st_model: FinalInfo, default: "投了"
        custom_belongs_to :xmode, ar_model: Xmode, st_model: XmodeInfo, default: "野良"

        scope :toryo_timeout_checkmate_only, -> { joins(:final).where(Final.arel_table[:key].eq_any(["TORYO", "TIMEOUT", "CHECKMATE"])) }

        normalizes :key, with: -> e { e.to_s } # BattleKey -> String

        # attr_accessor :csa_seq2

        before_validation on: :create do
          if Rails.env.local?
            # Bioshogi::Parser.parse(Bioshogi::Analysis::TagIndex.lookup(strike_plan).static_kif_file.read).to_csa
            if !kifu_body_for_test && !strike_plan
              # self.csa_seq ||= [["+7968GI", 599], ["-8232HI", 597], ["+5756FU", 594], ["-3334FU", 590], ["+6857GI", 592]]
              self.csa_seq ||= KifuGenerator.generate_n(5, {
                  # :time_list => [1, 3, 5, 7, 2],
                  :rule_key  => rule_key,
                  :hand_list => ["+7968GI", "-8232HI", "+5756FU", "-3334FU", "+6857GI"]
                })
            end

            (LocationInfo.count - memberships.size).times do
              memberships.build
            end

            memberships.each do |m|
              m.user ||= User.create!
            end
          end

          # memberships[0].opponent = memberships[1]
          # memberships[1].opponent = memberships[0]

          memberships[0].op_user ||= memberships[1].user
          memberships[1].op_user ||= memberships[0].user

          if Rails.env.local?
            unless key
              if Rails.env.test?
                self.key = BattleKeyGenerator.new(seed: self.class.count).generate.to_s
              else
                self.key = SecureRandom.hex
              end
            end
          end

          self.csa_seq ||= []

          # キーは "(先手名)-(後手名)-(日付)" となっているので最後を開始日時とする
          if battled_at.blank?
            if BattleKeyValidator.valid?(key)
              self.battled_at ||= BattleKey.create(key).to_time
            end
            self.battled_at ||= Time.current
          end
        end

        with_options presence: true do
          validates :key
          validates :battled_at
        end

        after_create do
          memberships[0].update_columns(:opponent_id => memberships[1].id)
          memberships[1].update_columns(:opponent_id => memberships[0].id)
        end
      end

      def to_param
        key
      end

      def key_info
        @key_info ||= BattleKey[key]
      end
      delegate *BattleKey::DELEGATE_METHODS, to: :key_info

      def battle_decorator_class
        BattleDecorator::SwarsBattleDecorator
      end

      def player_info
        memberships.inject({}) { |a, e|
          a.merge(e.location_info.key => {
              :name  => e.user.key,
              :class => e.judge_info.css_class,
            })
        }
      end

      # 将棋ウォーズの形式はCSAなのでパーサーを明示すると理論上は速くなる
      def parser_class
        if kifu_body_for_test || strike_plan
          return Bioshogi::Parser
        end
        Bioshogi::Parser::CsaParser
      end

      def heavy_parsed_info
        @heavy_parsed_info ||= KifuParser.new(kifu_parser_options)
      end

      # 棋譜コピー用
      def kifu_parser_options
        { source: kifu_body, swars_battle_key: key }
      end

      # def kifu_generator=(instance)
      #   @kifu_generator
      #   self.csa_seq = instance.csa_seq
      # end

      concerning :SummaryMethods do
        # for debug
        def info
          {
            "ID"       => id,
            "ルール"   => rule_info.name,
            "結末"     => final_info.name,
            "開始局面" => imode_info.name,
            "モード"   => xmode_info.name,
            "手合割"   => preset_info.name,
            "開戦"     => critical_turn,
            "中盤"     => outbreak_turn,
            "手数"     => turn_max,
            **memberships.inject({}) { |a, e| a.merge(e.location.name => e.name_with_grade_with_judge) },
            "対局日時" => battled_at.to_fs(:ymdhms),
            "対局秒数" => total_seconds,
            "終了日時" => end_at.to_fs(:ymdhms),
            "勝者"     => win_user&.key,
            "最終参照" => accessed_at.to_fs(:ymdhms),
            **tag_info,
          }.compact_blank
        end

        def total_seconds
          @total_seconds ||= memberships.sum(&:total_seconds)
        end

        def end_at
          @end_at ||= battled_at + total_seconds.seconds
        end
      end

      concerning :TimeChartMethods do
        def time_chart_datasets(accretion)
          memberships.collect.with_index { |e, i|
            {
              :label => e.user.key,  # グラフの上に出る名前
              :data  => e.time_chart_xy_list(accretion),
            }
          }
        end

        def time_chart_sec_list_of(location_info)
          memberships[location_info.code].sec_list
        end
      end
    end
  end
end
