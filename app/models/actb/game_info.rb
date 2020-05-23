module Actb
  class GameInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :game_key1, name: "マラソン",     },
      { key: :game_key2, name: "シングルトン", },
    ]

    def redis_key
      [self.class.name.demodulize.underscore, :matching_list, key].join("/")
    end
  end
end
