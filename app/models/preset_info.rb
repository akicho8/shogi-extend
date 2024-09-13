class PresetInfo < Bioshogi::PresetInfo
  include ApplicationMemoryRecord # これがなくても fetch は動くが db_record メソッドたちが必要なのでいる
  memory_record_reset superclass.collect(&:attributes)

  SWARS_PRESET_KEYS = [
    :"平手",
    :"角落ち",
    :"飛車落ち",
    :"二枚落ち",
    :"四枚落ち",
    :"六枚落ち",
    :"八枚落ち",
  ]

  class << self
    def swars_preset_infos
      @swars_preset_infos ||= array_from(SWARS_PRESET_KEYS)
    end
  end
end
