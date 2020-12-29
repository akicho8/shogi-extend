module UserTsMasterMod
  extend ActiveSupport::Concern

  included do
    has_many :ts_master_time_records, dependent: :destroy, class_name: "TsMaster::TimeRecord"
  end
end
