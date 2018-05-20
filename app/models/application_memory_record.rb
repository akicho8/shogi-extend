module ApplicationMemoryRecord
  extend ActiveSupport::Concern

  included do
    include MemoryRecord

    def self.as_hash_json(**options)
      inject({}) { |a, e| a.merge(e.key => e.as_json(options)) }.as_json
    end
  end

  def name
    key.to_s
  end
end
