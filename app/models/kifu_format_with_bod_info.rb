class KifuFormatWithBodInfo < Bioshogi::KifuFormatInfo
  memory_record_reset superclass.collect(&:attributes) + [
    { key: :bod }
  ]
end
