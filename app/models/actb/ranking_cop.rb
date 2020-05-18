# ランキング
#
# レーティング http://localhost:3000/script/actb-app.json?ranking_fetch=true&ranking_key=rating
# 連勝数       http://localhost:3000/script/actb-app.json?ranking_fetch=true&ranking_key=rensho_count
# 最大連勝数   http://localhost:3000/script/actb-app.json?ranking_fetch=true&ranking_key=rensho_max
#
module Actb
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
      retv[:user_rank_in] = top_users.any? { |e| e == current_user }
      retv[:current_user_rank_record] = { rank: user_rank, user: current_user.as_json(user_as_json_params) }
      retv[:rank_records] = top_users.collect.with_index(1) { |user, rank|
        { rank: rank, user: user.as_json(user_as_json_params) }
      }
      retv
    end

    def top_users
      @top_users ||= -> {
        s = base_scope
        s = s.order(Actb::Profile.arel_table[ranking_key].desc).order(:created_at)
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
      base_scope.where(Actb::Profile.arel_table[ranking_key].gt(user_score)).count.next
    end

    def ranking_key
      params[:ranking_key]
    end

    def base_scope
      s = Colosseum::User.all
      s = s.joins(:actb_profile)
      s = s.where(Actb::Profile.arel_table[:season_id].eq(Actb::Season.newest.id))
    end

    def user_score
      current_user.actb_newest_profile.public_send(ranking_key)
    end

    def current_user
      params[:current_user]
    end

    def user_as_json_params
      @user_as_json_params ||= { only: [:id, :name], methods: [:avatar_path, ranking_key] }
    end

    def record_max
      (params[:max].presence || RANKING_FETCH_MAX).to_i
    end
  end
end
