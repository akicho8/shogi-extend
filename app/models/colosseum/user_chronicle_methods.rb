module Colosseum
  concern :UserChronicleMethods do
    included do
      has_many :chronicles, dependent: :destroy

      if Rails.env.development? && false
        after_create do
          rand(10).times do
            judge_add(JudgeInfo.keys.sample)
          end
        end
      end
    end

    def win_count
      chronicles.judge_eq(:win).count
    end

    def lose_count
      chronicles.judge_eq(:lose).count
    end

    def win_ratio
      if total_count.zero?
        return 0.0
      end
      win_count.fdiv(total_count).round(3)
    end

    def total_count
      win_count + lose_count
    end

    def judge_add(key)
      judge_info = JudgeInfo.fetch(key)
      chronicles.create!(judge_key: judge_info.key)
    end
  end
end
