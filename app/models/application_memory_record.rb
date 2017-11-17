module ApplicationMemoryRecord
  extend ActiveSupport::Concern

  included do
    include MemoryRecord
  end
end
