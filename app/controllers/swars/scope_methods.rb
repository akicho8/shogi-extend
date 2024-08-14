module Swars
  concern :ScopeMethods do
    ################################################################################

    # これは index 専用としないとだめ。show で使うと Battle.none.find_by(id: xxx) でなんも引けなくなる
    def current_scope
      @current_scope ||= yield_self do
        case
        when v = params[:id] || params[:ids]
          Battle.where(id: v)
        when v = params[:key] || params[:keys] || primary_battle_key
          Battle.where(key: v)
        when params[:all]
          Battle.all
        when current_swars_user
          current_swars_user.battles.find_all_by_params(query_info: query_info, target_owner: current_swars_user, with_includes: true)
        when (v = params[:tag] || query_info.values.presence) && Rails.env.local? && false
          Battle.where(id: Membership.tagged_with(v).pluck(:battle_id)) # 1分ぐらいかかる
        else
          Battle.none
        end
      end
    end

    def current_index_scope
      @current_index_scope ||= current_scope
    end

    ################################################################################

    # http://localhost:3000/w.json?query=https://shogiwars.heroz.jp/games/alice-bob-20200101_123403
    # http://localhost:4000/swars/search?query=https://shogiwars.heroz.jp/games/alice-bob-20200101_123403
    def current_swars_user_key
      @current_swars_user_key ||= params[:user_key].presence || query_info.swars_user_key
    end

    def current_swars_user
      if current_swars_user_key
        @current_swars_user ||= User.find_by(user_key: current_swars_user_key)
      end
    end

    ################################################################################

    # 検索窓に棋譜URLが指定されたときの対局キー
    def primary_battle_key
      @primary_battle_key ||= yield_self do
        if query = params[:query].presence
          if battle_url = BattleUrlExtractor.new(query).battle_url
            battle_url.battle_key
          end
        end
      end
    end

    def primary_record
      @primary_record ||= yield_self do
        if primary_battle_key
          Swars::Battle.find_by(key: primary_battle_key)
        end
      end
    end

    ################################################################################
  end
end
