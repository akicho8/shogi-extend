module Swars
  class Battle
    concern :BasicMethods do
      class_methods do
        def create_with_members!(users, attributes = {})
          create!(attributes) do |e|
            users.each do |user|
              e.memberships.build(user: user)
            end
          end
        end
      end

      included do
        belongs_to :win_user, class_name: "Swars::User", optional: true # 勝者プレイヤーへのショートカット。引き分けの場合は入っていない。memberships.win.user と同じ

        has_many :memberships, -> { order(:position) }, dependent: :destroy, inverse_of: :battle

        has_many :users, through: :memberships

        scope :win_lose_only, -> { where.not(win_user_id: nil) } # 勝敗が必ずあるもの
        scope :newest_order, -> { order(battled_at: :desc) }     # 新しい順

        custom_belongs_to :rule,  ar_model: Rule,  st_model: RuleInfo,  default: "10分"
        custom_belongs_to :final, ar_model: Final, st_model: FinalInfo, default: "投了"
        custom_belongs_to :xmode, ar_model: Xmode, st_model: XmodeInfo, default: "通常"

        scope :toryo_timeout_checkmate_only, -> { joins(:final).where(Final.arel_table[:key].eq_any(["TORYO", "TIMEOUT", "CHECKMATE"])) }

        before_validation on: :create do
          if Rails.env.development? || Rails.env.test?
            # Bioshogi::Parser.parse(Bioshogi::TacticInfo.flat_lookup(tactic_key).sample_kif_file.read).to_csa
            if !kifu_body_for_test && !tactic_key
              self.csa_seq ||= [["+7968GI", 599], ["-8232HI", 597], ["+5756FU", 594], ["-3334FU", 590], ["+6857GI", 592]]
            end

            (LocationInfo.count - memberships.size).times do
              memberships.build
            end

            memberships.each do |m|
              m.user ||= User.create!
            end
          end

          memberships[0].op_user ||= memberships[1].user
          memberships[1].op_user ||= memberships[0].user

          self.key ||= KeyGenerator.generate(seed: self.class.count).to_s
          self.csa_seq ||= []

          # キーは "(先手名)-(後手名)-(日付)" となっているので最後を開始日時とする
          if battled_at.blank?
            if KeyVo.valid?(key)
              self.battled_at ||= KeyVo.wrap(key).to_time
            end
            self.battled_at ||= Time.current
          end
        end

        with_options presence: true do
          validates :key
          validates :battled_at
        end
      end

      def to_param
        key
      end

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
        if kifu_body_for_test || tactic_key
          return Bioshogi::Parser
        end
        Bioshogi::Parser::CsaParser
      end

      def heavy_parsed_info
        @heavy_parsed_info ||= KifuParser.new(source: kifu_body, swars_battle_key: key)
      end

      concerning :SummaryMethods do
        def total_seconds
          @total_seconds ||= memberships.sum(&:total_seconds)
        end

        def end_at
          @end_at ||= battled_at + total_seconds.seconds
        end
      end

      concerning :TimeChartMethods do
        def time_chart_datasets
          memberships.collect.with_index { |e, i|
            {
              label: e.user.key,  # グラフの上に出る名前
              data: e.time_chart_xy_list,
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
