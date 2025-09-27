# 最終判定
module Swars
  module FraudDetector
    module Judgement
      extend self

      # 判定には複数の方法がある
      mattr_accessor(:wave_count_threshold) { 3    } # 1. X回以上使用開始の模様があれば確定
      mattr_accessor(:drop_total_threshold) { 15   } # 2. X回以上代指しすれば確定
      mattr_accessor(:turn_max_threshold)   { 50   } # 3. (先後合わせて)N手以上の対局 かつ↓
      mattr_accessor(:two_freq_threshold)   { 0.6  } #    M以上の割合で 2 があると確定 (最大1.0)
      mattr_accessor(:gear_freq_threshold)  { 0.22 } # 4. 121の角が0.22以上(自分の指し手の60%が121ならと同じ)

      # 検索一覧時の個別判定
      def fraud?(membership)
        false ||
          (membership.ai_wave_count || 0) >= wave_count_threshold ||
          (membership.ai_drop_total || 0) >= drop_total_threshold ||
          ((membership.ai_two_freq || 0) >= two_freq_threshold && membership.battle.turn_max >= turn_max_threshold) ||
          ((membership.ai_gear_freq || 0) >= gear_freq_threshold && membership.battle.turn_max >= turn_max_threshold)
      end

      # プレイヤー情報用
      def fraud_only(scope)
        scope = scope.joins(:battle)

        c1 = Membership.where(Membership.arel_table[:ai_wave_count].gteq(wave_count_threshold))
        c2 = Membership.where(Membership.arel_table[:ai_drop_total].gteq(drop_total_threshold))

        c3a = Membership.where(Membership.arel_table[:ai_two_freq].gteq(two_freq_threshold))
        c3b = Battle.where(Battle.arel_table[:turn_max].gteq(turn_max_threshold))
        c3  = c3a.merge(c3b)

        c4a = Membership.where(Membership.arel_table[:ai_gear_freq].gteq(gear_freq_threshold))
        c4b = Battle.where(Battle.arel_table[:turn_max].gteq(turn_max_threshold))
        c4  = c4a.merge(c4b)

        scope.merge(c1.or(c2).or(c3).or(c4))
      end
    end
  end
end
