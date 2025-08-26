module Ppl
  class SpiderTypeInfo
    include ApplicationMemoryRecord
    memory_record [
      { klass: AncientSpider,   },
      { klass: AntiquitySpider, },
      { klass: MedievalSpider,  },
      { klass: ModernitySpider, },
    ]
  end
end
