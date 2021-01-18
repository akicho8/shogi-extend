# ランキング
#
# レーティング http://localhost:3000/api/wbook.json?remote_action=ranking_fetch&ranking_key=rating
# 連勝数       http://localhost:3000/api/wbook.json?remote_action=ranking_fetch&ranking_key=straight_win_count
# 最大連勝数   http://localhost:3000/api/wbook.json?remote_action=ranking_fetch&ranking_key=straight_win_max
#
# season_id もある場合がある
#
module Wbook
  class RankingCop
    RANKING_FETCH_MAX = 50

    attr_accessor :params

    def initialize(params)
      @params = params
    end

    def as_json(*)
      to_h.as_json
    end

    private

    def to_h
      retv = {}
      retv[:ranking_key] = ranking_key
      if current_user
        # ランクインしているか？
        retv[:user_rank_in] = top_users.include?(current_user)

        # ランクインしているどうかに関係なく、どっちみち表示するので、1回でもプレイしていたら情報取得
        if user_wbook_season_xrecord
          retv[:current_user_rank_record] = { rank: user_rank, user: current_user.as_json(user_as_json_params) }
        else
          # そのシーズンにはプレイしていなかった場合
        end
      end
      retv[:rank_records] = top_users.collect.with_index(1) { |user, i|
        { rank: i, user: user.as_json(user_as_json_params) }
      }
      retv
    end

    def top_users
      @top_users ||= -> {
        s = current_scope

        # 順序が重要
        s = s.order(Wbook::SeasonXrecord.arel_table[ranking_key].desc) # 勝数降順
        s = s.order(Wbook::SeasonXrecord.arel_table[:rating].desc)     # 内部レーティング降順
        s = s.order(:created_at)                                      # 古参

        s = s.limit(record_max)
        if params[:shuffle] == "true"
          s = s.shuffle
        end
        if v = params[:take].presence
          s = s.take(v.to_i)
        end
        s
      }.call
    end

    # 自分より上に何人いるかで自分の順位がわかる
    # SELECT COUNT(*)+1 as rank FROM users WHERE score > 自分のスコア
    def user_rank
      current_scope.where(Wbook::SeasonXrecord.arel_table[ranking_key].gt(user_score)).count.next
    end

    ################################################################################

    def current_scope
      s = User.all
      s = s.joins(:wbook_season_xrecord)
      s = s.where(Wbook::SeasonXrecord.arel_table[:season_id].eq(current_season.id)) # 指定シーズンの
      s = send("scope_for_#{ranking_key}", s)
      s
    end

    def scope_for_rating(s)
      s = s.where(Wbook::SeasonXrecord.arel_table[:battle_count].gteq(1)) # 1回以上プレイした人
    end

    def scope_for_straight_win_count(s)
      s = s.where(Wbook::SeasonXrecord.arel_table[:straight_win_count].gteq(1)) # 1連勝中以上
    end

    def scope_for_straight_win_max(s)
      s = s.where(Wbook::SeasonXrecord.arel_table[:straight_win_max].gteq(1)) # 最大1連勝以上
    end

    ################################################################################

    def user_score
      if v = user_wbook_season_xrecord
        v.public_send(ranking_key)
      end
    end

    def user_wbook_season_xrecord
      @user_wbook_season_xrecord ||= current_user.wbook_season_xrecords.where(season: current_season).take
    end

    def current_user
      params[:current_user]
    end

    def user_as_json_params
      @user_as_json_params ||= {
        only: [:id, :name],
        methods: [:avatar_path, :skill_key],
        include: {
          wbook_season_xrecord: {
            only: [ranking_key],
          },
        },
      }
    end

    def record_max
      (params[:max].presence || RANKING_FETCH_MAX).to_i
    end

    def current_season
      if v = params[:season_id].presence
        Wbook::Season.find(v)
      else
        Wbook::Season.newest
      end
    end

    def ranking_key
      params[:ranking_key]
    end
  end
end
