module Xclock
  class VoteInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :good, name: "高評価", },
      { key: :bad,  name: "低評価", },
    ]

    def flip
      self.class.fetch(key == :good ? :bad : :good)
    end
  end
end
