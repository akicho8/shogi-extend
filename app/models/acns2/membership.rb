module Acns2
  class Membership < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User" # , foreign_key: "colosseum_user_id"
    belongs_to :room

    acts_as_list top_of_list: 0, scope: :room

    before_validation do
      self.judge_key ||= :draw
      self.rensho_count ||= 0
      self.renpai_count ||= 0

      if changes_to_save[:judge_key] && judge_key
        if judge_key == "win" || judge_key == "lose"
          w = 0
          l = 0
          if record = maeno_record
            w = record.rensho_count
            l = record.renpai_count
          end
          if judge_key == "win"
            w += 1
          end
          if judge_key == "lose"
            l += 1
          end
          self.rensho_count = w
          self.renpai_count = l
        end
      end
    end

    def maeno_record
      s = user.acns2_memberships
      if created_at
        s = s.where(self.class.arel_table[:created_at].lt(created_at))
      end
      s = s.where(self.class.arel_table[:judge_key].eq_any(["win", "lose"]))
      s = s.order(:created_at)
      s.last
    end
  end
end
