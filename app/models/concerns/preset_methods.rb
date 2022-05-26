module PresetMethods
  extend ActiveSupport::Concern

  included do
    custom_belongs_to :preset, ar_model: Preset, st_model: PresetInfo, default: "平手"

    # before_validation do
    #   self.preset_id ||= Preset.fetch("平手").id
    # end
    #
    # with_options presence: true do
    #   validates :preset_id
    # end
    #
    # if Rails.env.development?
    #   with_options allow_blank: true do
    #     validates :preset_key, inclusion: PresetInfo.keys.collect(&:to_s)
    #   end
    # end
  end

  def preset_key_set(info)
  end
end
