module UserRaceMod
  extend ActiveSupport::Concern

  included do
    scope :robot_only, -> { where(race_key: :robot) }
    scope :human_only, -> { where(race_key: :human) }

    before_validation on: :create do
      self.race_key ||= race_info.key
    end
  end

  def race_info
    RaceInfo.fetch(race_key || :human)
  end

  def robot?
    race_info.key == :robot
  end

  def human?
    race_info.key == :human
  end
end
