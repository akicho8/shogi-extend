module PresetMethods
  extend ActiveSupport::Concern

  included do
    custom_belongs_to :preset, ar_model: Preset, st_model: PresetInfo, default: "平手"
  end

  def preset_key_set(info)
  end
end
