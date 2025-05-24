module Swars
  class BanInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :and,    name: "絞る", boolean_like_keys: [:on, :true],   yomiage: nil, },
      { key: :reject, name: "除外", boolean_like_keys: [:off, :false], yomiage: nil, },
    ]

    prepend AliasMod

    def secondary_key
      [name, *boolean_like_keys]
    end
  end
end
