# -*- coding: utf-8 -*-
# == Schema Information ==
#
# SeasonXrecord (emox_season_xrecords as Emox::SeasonXrecord)
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
# | rating_diff | Rating last diff | integer(4) | NOT NULL    |                       | J     |
# | rating_max       | Rating max       | integer(4) | NOT NULL    |                       | K     |
# | straight_win_count     | Rensho count     | integer(4) | NOT NULL    |                       | L     |
# | straight_lose_count     | Renpai count     | integer(4) | NOT NULL    |                       | M     |
# | straight_win_max       | Rensho max       | integer(4) | NOT NULL    |                       | N     |
# | straight_lose_max       | Renpai max       | integer(4) | NOT NULL    |                       | O     |
# | create_count     | Create count     | integer(4) | NOT NULL    |                       | P     |
# | generation       | Generation       | integer(4) | NOT NULL    |                       | Q     |
# | created_at       | 作成日時         | datetime   | NOT NULL    |                       |       |
# | updated_at       | 更新日時         | datetime   | NOT NULL    |                       |       |
# |------------------+------------------+------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :emox_season_xrecord
#--------------------------------------------------------------------------------

module Emox
  concern :XrecordShareMod do
    included do
      belongs_to :user, class_name: "::User"
      belongs_to :judge           # 直近バトルの勝敗
      belongs_to :final           # 直近バトルの結末

      scope :newest_order, -> { order(generation: :desc) }
      scope :oldest_order, -> { order(generation: :asc)  }

      with_options presence: true do
        validates :user_id
        validates :judge_id
        validates :final_id
      end

      before_validation do
        # レーティング
        self.rating ||= rating_default
        self.rating_max ||= rating
        self.rating_diff ||= 0

        # 勝敗関連
        self.battle_count ||= 0

        self.win_count  ||= 0
        self.lose_count ||= 0

        self.win_rate     ||= 0

        self.straight_win_count ||= 0
        self.straight_lose_count ||= 0
        self.straight_win_max   ||= 0
        self.straight_lose_max   ||= 0

        self.judge ||= Judge.fetch(:pending)

        # 結果関連
        self.disconnect_count ||= 0
        self.final ||= Final.fetch(:f_pending)

        # ウデマエ
        self.skill           ||= Skill.fetch(SkillInfo::DEFAULT)
        self.skill_point     ||= 0
        self.skill_last_diff ||= 0
      end
    end

    def rating_add(value)
      self.rating_diff = value
      self.rating += value
      if rating_max < rating
        self.rating_max = rating
      end
    end

    def judge_set(judge)
      self.judge = judge

      if judge.key == "draw"
        self.straight_win_count = 0
        self.straight_lose_count = 0

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
          self.straight_win_count += 1
          self.straight_lose_count = 0
        end
        if judge.key == "lose"
          self.straight_win_count = 0
          self.straight_lose_count += 1
        end

        self.straight_win_max = [straight_win_max, straight_win_count].max
        self.straight_lose_max = [straight_lose_max, straight_lose_count].max
      end
    end

    def final_set(final)
      self.final = final
      if final.key == "f_disconnect"
        self.disconnect_count += 1
        self.disconnected_at = Time.current
      end
    end

    def reset_all
      self.judge = nil
      self.final = nil

      self.battle_count = nil
      self.win_count = nil
      self.lose_count = nil
      self.win_rate = nil

      self.rating = nil
      self.rating_diff = nil
      self.rating_max = nil

      self.straight_win_count = nil
      self.straight_lose_count = nil

      self.straight_win_max = nil
      self.straight_lose_max = nil

      self.skill = nil
      self.skill_point = nil
      self.skill_last_diff = nil

      self.disconnect_count = nil
      self.disconnected_at = nil

      save!
    end

    concerning :SkillMethods do
      included do
        belongs_to :skill          # ウデマエ
      end

      # Rの変化度に応じてウデマエポイントも変化させる
      # 同じRで勝ったら+16で、それを C- の場合は 20 に換算する
      def skill_add_by_rating(judge, diff)
        if judge.win_or_lose?
          base = skill.pure_info.public_send(judge.key)
          point = Float(diff) * base / (EloRating::K / 2) # 16 * (20 / 16.0) -> 20
          if false
            p "#{diff} * #{base} / 16.0 --> #{point}"
          end
          skill_add(point)
        else
          # 引き分けのときは前回の差分を 0 にする
          skill_add(0)
        end
      end

      # レーティングに関係なく加算する
      def skill_add(diff)
        self.skill_last_diff = diff

        v = skill_point + diff
        rdiff, rest = v.divmod(SkillInfo::MAX)

        if rdiff.nonzero?
          next_skill = SkillInfo.lookup(skill.pure_info.code + rdiff.truncate)
          if next_skill
            self.skill = next_skill.db_record!
            self.skill_point = rest
          else
            # 最大99だとXのときカンストしていないように見えてしまう。そのため最大100にするのが正しい
            self.skill_point = v.clamp(0, SkillInfo::MAX)
          end
        else
          self.skill_point = v
        end
      end

      def skill_key
        if skill
          skill.key
        end
      end

      def skill_key=(v)
        self.skill = Skill.lookup(v)
      end
    end
  end
end
