# -*- coding: utf-8 -*-
# == Schema Information ==
#
# SeasonXrecord (actb_season_xrecords as Actb::SeasonXrecord)
#
# |------------------+------------------+------------+-------------+-----------------------+-------|
# | name             | desc             | type       | opts        | refs                  | index |
# |------------------+------------------+------------+-------------+-----------------------+-------|
# | id               | ID               | integer(8) | NOT NULL PK |                       |       |
# | user_id          | User             | integer(8) | NOT NULL    | => User#id | A! B  |
# | season_id        | Season           | integer(8) | NOT NULL    |                       | A! C  |
# | judge_id         | Judge            | integer(8) | NOT NULL    |                       | D     |
# | battle_count     | Battle count     | integer(4) | NOT NULL    |                       | E     |
# | win_count        | Win count        | integer(4) | NOT NULL    |                       | F     |
# | lose_count       | Lose count       | integer(4) | NOT NULL    |                       | G     |
# | win_rate         | Win rate         | float(24)  | NOT NULL    |                       | H     |
# | rating           | Rating           | integer(4) | NOT NULL    |                       | I     |
# | rating_last_diff | Rating last diff | integer(4) | NOT NULL    |                       | J     |
# | rating_max       | Rating max       | integer(4) | NOT NULL    |                       | K     |
# | rensho_count     | Rensho count     | integer(4) | NOT NULL    |                       | L     |
# | renpai_count     | Renpai count     | integer(4) | NOT NULL    |                       | M     |
# | rensho_max       | Rensho max       | integer(4) | NOT NULL    |                       | N     |
# | renpai_max       | Renpai max       | integer(4) | NOT NULL    |                       | O     |
# | create_count     | Create count     | integer(4) | NOT NULL    |                       | P     |
# | generation       | Generation       | integer(4) | NOT NULL    |                       | Q     |
# | created_at       | 作成日時         | datetime   | NOT NULL    |                       |       |
# | updated_at       | 更新日時         | datetime   | NOT NULL    |                       |       |
# |------------------+------------------+------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :actb_season_xrecord
#--------------------------------------------------------------------------------

module Actb
  concern :XrecordShareMod do
    included do
      belongs_to :user, class_name: "::User"
      belongs_to :judge           # 直近バトルの勝敗
      belongs_to :final           # 直近バトルの結末
      belongs_to :udemae          # ウデマエ

      scope :newest_order, -> { order(generation: :desc) }
      scope :oldest_order, -> { order(generation: :asc)  }

      before_validation do
        # レーティング
        self.rating ||= rating_default
        self.rating_max ||= rating
        self.rating_last_diff ||= 0

        # 勝敗関連
        self.battle_count ||= 0

        self.win_count  ||= 0
        self.lose_count ||= 0

        self.win_rate     ||= 0

        self.rensho_count ||= 0
        self.renpai_count ||= 0
        self.rensho_max   ||= 0
        self.renpai_max   ||= 0

        self.judge ||= Judge.fetch(:pending)

        # 結果関連
        self.disconnect_count ||= 0
        self.final ||= Final.fetch(:f_pending)

        # ウデマエ
        self.udemae       ||= Udemae.fetch(UdemaeInfo::DEFAULT)
        self.udemae_point ||= 0
      end
    end

    def rating_add(value)
      self.rating_last_diff = value
      self.rating += value
      if rating_max < rating
        self.rating_max = rating
      end
    end

    def judge_set(judge)
      self.judge = judge

      if judge.key == "draw"
        self.rensho_count = 0
        self.renpai_count = 0

        self.battle_count += 1
        self.win_rate = win_count.fdiv(battle_count)
      end

      if judge.win_or_lose?
        self.battle_count += 1

        # 総勝敗
        public_send("#{judge.key}_count=", public_send("#{judge.key}_count") + 1)

        # d = win_count + lose_count
        # if d.positive?
        #   self.win_rate = win_count.fdiv(d)
        # end

        self.win_rate = win_count.fdiv(battle_count)

        # 連勝敗
        if judge.key == "win"
          self.rensho_count += 1
          self.renpai_count = 0
        end
        if judge.key == "lose"
          self.rensho_count = 0
          self.renpai_count += 1
        end

        self.rensho_max = [rensho_max, rensho_count].max
        self.renpai_max = [renpai_max, renpai_count].max
      end
    end

    def final_set(final)
      self.final = final
      if final.key == "f_disconnect"
        self.disconnect_count += 1
        self.disconnected_at = Time.current
      end
    end

    # Rの変化度に応じてウデマエポイントも変化させる
    # 同じRで勝ったら+16で、それを C- の場合は 20 に換算する
    def udemae_add_by_rating(judge, diff)
      if judge.win_or_lose?
        base = udemae.pure_info.public_send(judge.key)
        point = Float(diff) * base / (EloRating::K / 2) # 16 * (20 / 16.0) -> 20
        if false
          p "#{diff} * #{base} / 16.0 --> #{point}"
        end
        udemae_add(point)
      end
    end

    # レーティングに関係なく加算する
    def udemae_add(diff)
      v = udemae_point + diff
      rdiff, rest = v.divmod(UdemaeInfo::MAX)

      if rdiff.nonzero?
        next_udemae = UdemaeInfo.lookup(udemae.pure_info.code + rdiff)
        if next_udemae
          self.udemae = next_udemae.db_record!
          self.udemae_point = rest
        else
          self.udemae_point = v.clamp(0, UdemaeInfo::MAX.pred)
        end
      else
        self.udemae_point = v
      end
    end
  end
end
