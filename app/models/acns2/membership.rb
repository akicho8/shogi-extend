module Acns2
  class Membership < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User" # , foreign_key: "colosseum_user_id"
    belongs_to :room

    acts_as_list top_of_list: 0, scope: :room

    before_validation do
      self.rensho_count ||= 0
      self.renpai_count ||= 0

      if changes_to_save[:judge_key] && judge_key
        w = 0
        l = 0
        if record = maeno_record
          w = record.rensho_count
          l = record.renpai_count
        end
        if judge_key == "win"
          w += 1
          l = 0
        end
        if judge_key == "lose"
          w = 0
          l += 1
        end
        self.rensho_count = w
        self.renpai_count = l
      end
    end

    with_options allow_blank: true do
      validates :judge_key, inclusion: JudgeInfo.keys.collect(&:to_s)
      validates :judge_key, uniqueness: { scope: :room_id, case_sensitive: true }
    end

    after_save do
      user.acns2_profile.update!(rensho_count: rensho_count, renpai_count: renpai_count)
    end

    def maeno_record
      s = user.acns2_memberships
      if created_at
        s = s.where(self.class.arel_table[:created_at].lt(created_at))
      end
      s = s.where.not(judge_key: nil)
      s = s.order(:created_at)
      s.last
    end
  end
end
