# frozen-string-literal: true

# http://localhost:3000/w.json?query=嬉野流

module Swars
  class QueryResolver
    class << self
      def resolve(...)
        new(...).resolve
      end
    end

    RESOLVE_METHODS = [
      :resolve_by_params_id,
      :resolve_by_params_key,

      :resolve_by_item_infos,
      :resolve_by_grade_infos,
      :resolve_by_preset_infos,
      :resolve_by_style_infos,

      :resolve_by_params_all,
      :resolve_by_params_ban,
      :resolve_by_query_id_and_key,
      :resolve_by_current_swars_user,
      :resolve_by_params_tag_local_only,
      :resolve_by_unknown,
    ]

    attr_reader :context

    def initialize(context)
      @context = context
    end

    def call
      resolve
    end

    def resolve
      scope = nil
      RESOLVE_METHODS.each do |e|
        if v = send(e)
          scope = v
          break
        end
      end
      scope
    end

    def resolve_by_params_id
      if v = params[:id].presence || params[:ids].presence
        Battle.where(id: v.to_s.scan(/\d+/))
      end
    end

    def resolve_by_params_key
      if v = params[:key].presence || params[:keys].presence || primary_battle_key
        Battle.where(key: v)
      end
    end

    # 「嬉野流 居玉」として AND 検索したかったが、
    # 「居玉の嬉野流」であっても「居玉」で検索した ID が含まれるとは限らないので、
    # あらかじめ一定の対局IDsを収集しておく仕様とは噛み合わない
    # でも一応できるようにはしておく
    # つまり「嬉野流 居玉」では、運が良ければ AND 検索になる
    def resolve_by_item_infos
      if items = query_info.item_infos.presence
        ids_ary = items.collect { |e| battle_id_collector.tactic_battle_ids_hash[e.key] }.compact # それぞれの IDs を収集する
        ids = ids_ary.inject { |a, e| a & e }                          # 絞り込み
        Battle.where(id: ids)
      end
    end

    def resolve_by_grade_infos
      if grade_infos = query_info.grade_infos.presence
        ids_ary = grade_infos.collect { |e| battle_id_collector.grade_battle_ids_hash[e.key] }.compact # それぞれの IDs を収集する
        ids = ids_ary.inject { |a, e| a & e }                          # 絞り込み
        Battle.where(id: ids)
      end
    end

    def resolve_by_preset_infos
      if preset_infos = query_info.preset_infos.presence
        ids_ary = preset_infos.collect { |e| battle_id_collector.preset_battle_ids_hash[e.key] }.compact # それぞれの IDs を収集する
        ids = ids_ary.inject { |a, e| a & e }                          # 絞り込み
        Battle.where(id: ids)
      end
    end

    def resolve_by_style_infos
      if style_infos = query_info.style_infos.presence
        ids_ary = style_infos.collect { |e| battle_id_collector.style_battle_ids_hash[e.key] }.compact # それぞれの IDs を収集する
        ids = ids_ary.inject { |a, e| a & e }                          # 絞り込み
        Battle.where(id: ids)
      end
    end

    def resolve_by_params_all
      if params[:all]
        Battle.all
      end
    end

    def resolve_by_params_ban
      if params[:ban]
        Battle.ban_only
      end
    end

    def resolve_by_query_id_and_key
      if query_info.lookup_first([:id, :ids, :key, :keys])
        Battle.find_all_by_params(query_info: query_info)
      end
    end

    def resolve_by_current_swars_user
      if current_swars_user
        current_swars_user.battles.find_all_by_params(query_info: query_info, target_owner: current_swars_user, with_includes: true)
      end
    end

    def resolve_by_params_tag_local_only
      if Rails.env.local?
        if v = params[:tag]
          Battle.where(id: Membership.tagged_with(v).pluck(:battle_id)) # 1分ぐらいかかる
        end
      end
    end

    def resolve_by_unknown
      Battle.none
    end

    private

    ################################################################################

    def params
      context[:params] || {}
    end

    def query_info
      context[:query_info] || QueryInfo.null
    end

    def current_swars_user_key
      context[:current_swars_user_key]
    end

    def current_swars_user
      context[:current_swars_user]
    end

    def primary_battle_key
      context[:primary_battle_key]
    end

    def primary_battle
      context[:primary_battle]
    end

    ################################################################################

    def battle_id_collector
      @battle_id_collector ||= QuickScript::Swars::BattleIdCollector.new
    end

    ################################################################################
  end
end
