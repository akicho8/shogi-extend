class LocationInfo < Bioshogi::Location
  include ApplicationMemoryRecord
  memory_record_reset superclass.collect(&:attributes)
end
