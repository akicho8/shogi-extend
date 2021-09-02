class ImageSizeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :width,  default: 1200, max: 4096, },
    { key: :height, default:  630, max: 4096, },
  ]
end
