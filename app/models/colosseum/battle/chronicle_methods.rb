module Colosseum
  module Battle::ChronicleMethods
    extend ActiveSupport::Concern

    included do
      with_options allow_blank: true do
        validates :win_location_key, inclusion: Bioshogi::Location.keys.collect(&:to_s)
        validates :last_action_key, inclusion: LastActionInfo.keys.collect(&:to_s)
      end

      after_save do
        if saved_changes[:end_at] && end_at
          if saved_changes[:last_action_key] && last_action_info
            if win_location_info
              memberships.each do |e|
                if e.location.key == win_location_info.key
                  judge_key = :win
                else
                  judge_key = :lose
                end
                e.user.judge_add(judge_key)
              end
            end
          end
        end
      end
    end

    def win_location_info
      Bioshogi::Location.fetch_if(win_location_key)
    end

    def last_action_info
      LastActionInfo.fetch_if(last_action_key)
    end
  end
end
