module Ppl
  class ResultInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :promotion,   name: "昇段", official_mark: "昇", short_name: "昇段", },
      { key: :runner_up,   name: "次点", official_mark: "次", short_name: "次点", },
      { key: :retain,      name: "維持", official_mark: "維", short_name: "",     },
      { key: :demotion,    name: "降点", official_mark: "降", short_name: "降点", },
      { key: :resignation, name: "退会", official_mark: "退", short_name: "退会", },
    ]

    prepend AliasMod

    def secondary_key
      [name, official_mark]
    end
  end
end
