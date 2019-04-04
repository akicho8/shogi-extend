module Swars
  class ChartTagInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "ibisha",       name: "居飛車",      },
      { key: "furibisha",    name: "振り飛車",    },
      { key: "sou_furibisha",name: "相振り飛車",  },
      { key: "taikou_kata",  name: "対抗型",      },
      { key: "sou_ibisha",   name: "相居飛車",    },
    ]

    def canvas_id
      "#{key}_canvas"
    end

    def chart_params_for(user)
      {
        canvas_id: canvas_id,
        chart_params: {
          type: "pie", # doughnut
          options: {
            title: {
              display: true,
              text: name,
            },
          },
          data: {
            labels: ["勝ち", "負け"],
            datasets: [
              {
                data: [:win, :lose].collect { |judge_key| user.memberships.tagged_with(name, on: :note_tags).where(judge_key: judge_key).count },
                backgroundColor: [:win, :lose].collect.with_index { |e, i| PaletteInfo[i].pie_color },
              },
            ],
          },
        },
      }
    end
  end
end
