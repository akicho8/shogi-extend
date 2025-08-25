module Ppl
  class SpiderTypeInfo
    include ApplicationMemoryRecord
    memory_record [
      { klass: AntiquitySpider, },
      { klass: MedievalSpider,  },
      { klass: ModernitySpider, },
    ]
  end
end
