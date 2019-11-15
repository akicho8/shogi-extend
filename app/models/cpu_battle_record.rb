class CpuBattleRecord < ApplicationRecord
  class << self
    def setup(options = {})
      unless Rails.env.production?
        create!(user: Colosseum::User.sysop, judge_key: :win)
        create!(user: nil,                   judge_key: :lose)
      end
    end
  end

  belongs_to :user, class_name: "Colosseum::User", foreign_key: "colosseum_user_id", required: false

  with_options presence: true do
    validates :judge_key
  end

  with_options allow_blank: true do
    validates :judge_key, inclusion: JudgeInfo.keys.collect(&:to_s)
  end
end
