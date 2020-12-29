module UserXyMasterMod
  extend ActiveSupport::Concern

  included do
    has_many :xy_master_time_records, dependent: :destroy, class_name: "XyMaster::TimeRecord"
  end
end
