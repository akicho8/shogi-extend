module Ppl
  class SpiderTypeInfo
    include ApplicationMemoryRecord
    memory_record [
      { klass: AntiquitySpider, },
      { klass: MedievalSpider,  },
      { klass: ModernitySpider, },
    ]

    class << self
      # 未使用
      def priority_map
        @priority_map ||= flat_map { |e| e.klass.accept_range.to_a }.collect.with_index { |e, i| [e, i] }.to_h
      end
    end
  end
end
