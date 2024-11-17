module PresetMethods
  extend ActiveSupport::Concern

  included do
    custom_belongs_to :preset, ar_model: Preset, st_model: PresetInfo, default: "平手"

    delegate :handicap, to: :preset_info
  end

  def preset_key_set
  end
end
