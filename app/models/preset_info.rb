class PresetInfo < Bioshogi::PresetInfo
  include ApplicationMemoryRecord
  memory_record_reset superclass.collect(&:attributes)
end
