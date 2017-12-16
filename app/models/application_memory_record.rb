module ApplicationMemoryRecord
  extend ActiveSupport::Concern

  included do
    include MemoryRecord
  end

  def name
    key.to_s
  end
end
