# 最終棋神判定
# ~/src/shogi-extend/experiment/swars/ai_cop/judgement.rb
module Swars
  module AiCop
    module Judgement
      extend self

      # 棋神判定には3つ方法がある
      mattr_accessor(:wave_count_threshold) { 3   } # 1. N回以上棋神使用開始の模様があれば棋神確定
      mattr_accessor(:drop_total_threshold) { 15  } # 2. N回以上代指しすれば棋神確定
      mattr_accessor(:turn_max_threshold)   { 50  } # 3. (先後合わせて)N手以上の対局 かつ↓
      mattr_accessor(:two_freq_threshold)   { 0.6 } #    M以上の割合で 2 があると棋神確定 (最大1.0)

      # 検索一覧時の個別判定
      def membership_arrest?(membership)
        false ||
          (membership.ai_wave_count || 0) >= wave_count_threshold ||
          (membership.ai_drop_total || 0) >= drop_total_threshold ||
          ((membership.ai_two_freq || 0) >= two_freq_threshold && membership.battle.turn_max >= turn_max_threshold)
      end

      # プレイヤー情報用
      def arrest_scope(s)
        s = s.joins(:battle)
        c1 = Membership.where(Membership.arel_table[:ai_wave_count].gteq(wave_count_threshold))
        c2 = Membership.where(Membership.arel_table[:ai_drop_total].gteq(drop_total_threshold))
        c3a = Membership.where(Membership.arel_table[:ai_two_freq].gteq(two_freq_threshold))
        c3b = Battle.where(Battle.arel_table[:turn_max].gteq(turn_max_threshold))
        s.merge(c1.or(c2).or(c3a.merge(c3b)))
      end
    end
  end
end
