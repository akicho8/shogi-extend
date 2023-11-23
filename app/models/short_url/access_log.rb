module ShortUrl
  class AccessLog < ApplicationRecord
    belongs_to :component, counter_cache: true, touch: true
  end
end
