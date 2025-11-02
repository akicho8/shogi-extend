module Swars
  class BattlesController
    concern :ScopeMod do
      ################################################################################

      # これは index 専用としないとだめ。show で使うと Battle.none.find_by(id: xxx) でなんも引けなくなる
      def current_scope
        @current_scope ||= QueryResolver.resolve(query_resolver_context)
      end

      def query_resolver_context
        {
          :params                 => params,
          :query_info             => query_info,
          :current_swars_user_key => current_swars_user_key,
          :current_swars_user     => current_swars_user,
          :primary_battle_key     => primary_battle_key,
          :primary_battle         => primary_battle,
        }
      end

      def current_index_scope
        @current_index_scope ||= current_scope
      end

      ################################################################################

      # http://localhost:3000/w.json?query=https://shogiwars.heroz.jp/games/alice-bob-20200101_123403
      # http://localhost:4000/swars/search?query=https://shogiwars.heroz.jp/games/alice-bob-20200101_123403
      def current_swars_user_key
        @current_swars_user_key ||= UserKey.safe_create((params[:user_key].presence || query_info.swars_user_key).to_s)
      end

      def current_swars_user
        # return @current_swars_user if defined?(@current_swars_user)
        @current_swars_user ||= yield_self do
          if current_swars_user_key
            User.find_by(user_key: current_swars_user_key)
          end
        end
      end

      ################################################################################

      # 検索窓に棋譜URLが指定されたときの対局キー
      def primary_battle_key
        # return @primary_battle_key if defined?(@primary_battle_key)
        @primary_battle_key ||= yield_self do
          if query = params[:query].presence
            if battle_url = BattleUrlExtractor.new(query).battle_url
              battle_url.battle_key
            end
          end
        end
      end

      def primary_battle
        # return @primary_battle if defined?(@primary_battle)
        @primary_battle ||= yield_self do
          if primary_battle_key
            Swars::Battle.find_by(key: primary_battle_key)
          end
        end
      end

      ################################################################################
    end
  end
end
