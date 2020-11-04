module Emox
  class BattleJudgeFinalSet
    attr_accessor :battle
    attr_accessor :params

    def initialize(battle, params)
      @battle = battle
      @params = params
    end

    def run
      hard_validation

      ActiveRecord::Base.transaction do
        it = judges.each
        memberships.each.with_index do |m|
          m.update!(judge: it.next)
        end

        [:emox_main_xrecord, :emox_latest_xrecord].each do |method|
          judge_it = judges.each
          diff = diffs_get(method)

          memberships.each do |m|
            judge = judge_it.next
            sdiff = diff * judge.pure_info.sign_value # 引き分けの場合は 0 * 0 になる

            r = m.user.send(method)

            # 順序に意味はない
            r.rating_add(sdiff)                  # レーティング更新
            r.skill_add_by_rating(judge, sdiff)  # ウデマエ更新(レーティングの変化度を考慮)
            r.judge_set(judge)                   # 勝敗
            r.final_set(final)                   # 結果

            r.save!
          end
        end

        battle.final = final
        battle.save!
      end
    end

    private

    def hard_validation
      if battle.end_at
        raise "すでに終了している"
      end
    end

    def diffs_get(method)
      if target_user
        values = memberships.collect { |e| e.user.send(method).rating }
        EloRating.rating_update1(*values)
      else
        0
      end
    end

    # [勝ちユーザー, 負けユーザー] の順にする
    def memberships
      @memberships ||= -> {
        if target_user
          m1 = battle.memberships.find_by!(user: target_user)
          m2 = (battle.memberships - [m1]).first
          if judge.win_or_lose?
            if judge.key == "win"
              [m1, m2]
            else
              [m2, m1]
            end
          else
            battle.memberships
          end
        else
          battle.memberships
        end
      }.call
    end

    # 勝敗があるときだけ [勝ち, 負け] の順にする
    def judges
      @judges ||= -> {
        if judge.win_or_lose?
          [Judge.fetch(:win), Judge.fetch(:lose)]
        else
          [judge, judge]
        end
      }.call
    end

    def target_user
      params[:target_user]
    end

    def judge
      Judge.fetch(params[:judge_key])
    end

    def final
      Final.fetch(params[:final_key])
    end
  end
end
