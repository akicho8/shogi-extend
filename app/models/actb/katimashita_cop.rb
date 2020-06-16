module Actb
  class KatimashitaCop
    attr_accessor :battle
    attr_accessor :params

    def initialize(battle, params)
      @battle = battle
      @params = params
    end

    def run
      hard_validation

      ActiveRecord::Base.transaction do
        # Actb::SeasonXrecord
        mm.each.with_index do |m, i|
          judge = judges[i]

          # 今期の更新
          record = m.user.actb_current_xrecord
          record.rating_add(c_diffs[i])
          record.udemae_point_add2(judge, m_diffs[i])
          record.judge_set(judge)
          record.final_set(final)
          record.save!

          # 永続的情報の更新
          record = m.user.actb_master_xrecord
          record.rating_add(m_diffs[i])
          record.udemae_point_add2(judge, m_diffs[i])
          record.judge_set(judge)
          record.final_set(final)
          record.save!

          # Membership 自体に結果を埋める
          m.judge = judge
          m.save!
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

    # 今シーズン用
    def c_diffs
      @c_diffs ||= -> {
        if target_user
          values = mm.collect { |e| e.user.actb_current_xrecord.rating }
          EloRating.plus_minus_retval(:rating_update2, *values)
        else
          [0, 0]
        end
      }.call
    end

    # 永続的記録用
    def m_diffs
      @m_diffs ||= -> {
        if target_user
          m_ratings = mm.collect { |e| e.user.actb_master_xrecord.rating }
          EloRating.plus_minus_retval(:rating_update2, *m_ratings)
        else
          [0, 0]
        end
      }.call
    end

    def mm
      @mm ||= -> {
        m1 = battle.memberships.find_by!(user: target_user)
        m2 = (battle.memberships - [m1]).first

        mm = [m1, m2]
        if judge.key != "win"
          mm = mm.reverse
        end
        mm
      }.call
    end

    def target_user
      params[:target_user]
    end

    def judge
      Judge.fetch(params[:judge_key])
    end

    def judges
      @judges ||= -> {
        list = [judge, judge.flip]
        if judge.key != "win"
          list = list.reverse
        end
        list
      }.call
    end

    def final
      Final.fetch(params[:final_key])
    end
  end
end
