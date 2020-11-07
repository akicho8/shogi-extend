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
