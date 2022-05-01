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

        begin
          belongs_to :rule
          scope :rule_eq,     -> v { where(    rule_key: RuleInfo.keys_from(v)) }
          scope :rule_not_eq, -> v { where.not(rule_key: RuleInfo.keys_from(v)) }
          scope :rule_ex,     proc { |v; s, g|
            s = all
            g = xquery_parse(v)
            if g[true]
              s = s.rule_eq(g[true])
            end
            if g[false]
              s = s.rule_not_eq(g[false])
            end
            s
          }
        end

        begin
          belongs_to :final
          scope :final_eq,     -> v { where(    final_key: FinalInfo.keys_from(v)) }
          scope :final_not_eq, -> v { where.not(final_key: FinalInfo.keys_from(v)) }
          scope :final_ex,     proc { |v; s, g|
            s = all
            g = xquery_parse(v)
            if g[true]
              s = s.final_eq(g[true])
            end
            if g[false]
              s = s.final_not_eq(g[false])
            end
            s
          }
        end

        begin
          belongs_to :xmode
          scope :xmode_eq,     -> v { where(    xmode: Xmode.array_from(v)) }
          scope :xmode_not_eq, -> v { where.not(xmode: Xmode.array_from(v)) }
          scope :xmode_ex,     proc { |v; s, g|
            s = all
            g = xquery_parse(v)
            if g[true]
              s = s.xmode_eq(g[true])
            end
            if g[false]
              s = s.xmode_not_eq(g[false])
            end
            s
          }
        end

        before_validation do
          self.xmode_id ||= Xmode.fetch("通常").id
          self.rule_id  ||= Rule.fetch("10分").id
          self.final_id ||= Final.fetch("投了").id
        end

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

          self.rule_key ||= :ten_min

          # "" から ten_min への変換
          if rule_key
            self.rule_key = RuleInfo.fetch(rule_key).key
          end

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
          self.final_key ||= :TORYO
        end

        with_options presence: true do
          validates :key
          validates :battled_at
          validates :rule_key
          validates :final_key
          validates :xmode_id
          validates :rule_id
          validates :final_id
        end

        with_options allow_blank: true do
          if false
            # ・このバリデーションは不要
            # ・RecordInvalid になってしまうから
            # ・別にフォームじゃないので必要ない
            # ・DB の index: { unique: true } にまかせる方がよい
            # ・RecordNotUnique なら controller 側で判定できる
            validates :key, uniqueness: { case_sensitive: true }
          end
          validates :final_key, inclusion: FinalInfo.keys.collect(&:to_s)
        end

        # after_create do
        #   memberships.each(&:opponent_id_set_if_blank)
        # end
      end

      def to_param
        key
      end

      def rule_info
        RuleInfo.fetch(rule_key)
      end

      def final_info
        FinalInfo.fetch(final_key)
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
