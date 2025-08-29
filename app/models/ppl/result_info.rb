module Ppl
  class ResultInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :promotion, name: "昇段", official_mark: "昇", short_name: "昇段", },
      { key: :demotion,  name: "降段", official_mark: "降", short_name: "降段", },
      { key: :runner_up, name: "次点", official_mark: "次", short_name: "次点", },
      { key: :retain,    name: "維持", official_mark: "維", short_name: "",     },
    ]

    prepend AliasMod

    def secondary_key
      [name, official_mark]
    end
  end
end
