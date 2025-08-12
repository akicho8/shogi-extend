module Tsl
  class ResultInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :promotion, name: "昇段", official_mark: "昇", },
      { key: :demotion,  name: "降段", official_mark: "降", },
      { key: :runner_up, name: "次点", official_mark: "次", },
      { key: :retain,    name: "維持", official_mark: "維", },
    ]

    prepend AliasMod

    def secondary_key
      [name, official_mark]
    end
  end
end
