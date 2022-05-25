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

          if Rails.env.development? || Rails.env.test?
            self.key ||= "#{self.class.name.demodulize.underscore}#{self.class.count.next}"
          end
          self.key ||= SecureRandom.hex

          self.csa_seq ||= []

          # self.rule_key ||= :ten_min

          # "" から ten_min への変換
          # if rule_key
          #   self.rule_key = RuleInfo.fetch(rule_key).key
          # end

          # キーは "(先手名)-(後手名)-(日付)" となっているので最後を開始日時とする
          if key
            if key.include?("-")
              ymd_str = key.split("-").last
              if ymd_str.match?(/\A\d+_\d+\z/)
                self.battled_at ||= Time.zone.parse(ymd_str) rescue nil
              end
            end
          end

          # if Rails.env.development? || Rails.env.test?
          #   self.battled_at ||= Time.current + (self.class.count * 6.hour)
          # end

          self.battled_at ||= Time.current
          # self.final_key ||= :TORYO
        end

        with_options presence: true do
          validates :key
          validates :battled_at

          # validates :rule_key
          # validates :final_key

          # validates :rule_id
          # validates :final_id
          # validates :xmode_id
        end

        # if Rails.env.development?
        #   with_options allow_blank: true do
        #     validates :rule_key,  inclusion: RuleInfo.keys.collect(&:to_s)
        #     validates :final_key, inclusion: FinalInfo.keys.collect(&:to_s)
        #     validates :xmode_key, inclusion: XmodeInfo.keys.collect(&:to_s)
        #   end
        # end

        # after_create do
        #   memberships.each(&:opponent_id_set_if_blank)
        # end
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

      concerning :ViewHelper do
        def left_right_memberships(current_swars_user)
          a = memberships.to_a
          if current_swars_user
            if a.last.user == current_swars_user # 対象者がいるときは対象者を左
              a = a.reverse
            end
          else
            if win_user_id
              if a.last.judge_key == "win" # 対象者がいないときは勝った方を左
                a = a.reverse
              end
            end
          end
          a
        end
      end
    end
  end
end
