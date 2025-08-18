# frozen-string-literal: true

module Swars
  module User::Stat
    class ScopeExt < Base
      DELEGATE_METHODS = [
        :scope_ids,
        :ids_scope,
        :ids_count,
        :ordered_ids_scope,
        :sample_max,
      ]

      include SubScopeMethods

      cattr_accessor(:max_of_sample_max) { Rails.env.local? ? 10000 : 1000 }

      delegate *[
        :user,
        :params,
        :filtered_battle_ids,
      ], to: :stat

      def initialize(stat, scope)
        super(stat)
        @scope = scope
      end

      # この IDs は直近順に並んでいる
      def scope_ids
        @scope_ids ||= base_scope.ids
      end

      # すべてのクエリはこれ元に行えば高速に引ける
      def ids_scope
        @ids_scope ||= Membership.where(id: scope_ids).extending(MembershipExtension)
      end

      # 総数
      def ids_count
        @ids_count ||= ids_scope.count
      end

      # 並びを維持したスコープ
      def ordered_ids_scope
        @ordered_ids_scope ||= ids_scope.order([Arel.sql("FIELD(#{Membership.table_name}.id, ?)"), scope_ids])
      end

      def sample_max
        @sample_max ||= yield_self do
          max = (params[:sample_max].presence || default_params[:sample_max]).to_i
          [max, max_of_sample_max].min
        end
      end

      private

      # 最優先の必須スコープ
      # 直近 50 件が最優先でそのなかから win, lose を抽出する
      # これがまざってしまうと win, lose のみのものが 50 件となってしまう
      #
      # Swars::Membership Ids (40.7ms)  SELECT swars_memberships.id FROM swars_memberships INNER JOIN swars_battles ON swars_battles.id = swars_memberships.battle_id WHERE swars_memberships.user_id = 17413 ORDER BY swars_battles.battled_at DESC LIMIT 50
      #
      def base_scope
        s = @scope.joins(:battle).merge(Battle.latest_order)
        if ids = filtered_battle_ids
          s = s.where(battle: ids)
        end
        s = s.limit(sample_max)
      end
    end
  end
end
