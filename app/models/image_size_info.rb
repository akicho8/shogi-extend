class ImageSizeInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :width,  default: 1200, max: Rails.env.development? ? 3200 : 1600, },
    { key: :height, default:  630, max: Rails.env.development? ? 3200 : 1200, },
  ]
end
