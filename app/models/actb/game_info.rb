module Actb
  class GameInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :game_key1 },
      { key: :game_key2 },
    ]

    def redis_key
      [:matching_list, key].join("/")
    end
  end
end
