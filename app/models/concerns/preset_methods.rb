module PresetMethods
  extend ActiveSupport::Concern

  included do
    belongs_to :preset

    scope :preset_eq,     -> v { where(    preset_key: PresetInfo.keys_from(v)) }
    scope :preset_not_eq, -> v { where.not(preset_key: PresetInfo.keys_from(v)) }
    scope :preset_ex, proc  { |v; s, g| # NOTE: ruby 2.6.5 では -> (v; s, g) と書けないため proc にしている
      s = all
      g = xquery_parse(v)
      if g[true]
        s = s.preset_eq(g[true])
      end
      if g[false]
        s = s.preset_not_eq(g[false])
      end
      s
    }

    before_validation do
      self.preset_key ||= :"平手"
      self.preset ||= Preset.fetch("平手")
    end

    with_options presence: true do
      validates :preset_key
    end

    with_options allow_blank: true do
      validates :preset_key, inclusion: PresetInfo.keys.collect(&:to_s)
    end
  end

  def preset_info
    PresetInfo.fetch(preset_key)
  end

  def preset_key_set(info)
  end
end
