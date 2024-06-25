# Nuxt でなかったころに使っていた残骸

module Swars
  class ChartTagInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: "ibisha",    name: "居飛車",      },
      { key: "furibisha", name: "振り飛車",    },

      { key: "ai_ibisha", name: "相居飛車",    },
      { key: "taikoukei", name: "対抗形",      },
      { key: "aifuri",    name: "相振り飛車",      },
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
            labels: WinLoseInfo.collect(&:name),
            datasets: [
              {
                data: WinLoseInfo.collect { |e| user.memberships.tagged_with(name, on: :note_tags).s_where_judge_key_eq(e.key).count },
                backgroundColor: WinLoseInfo.collect { |e| e.palette.pie_color },
              },
            ],
          },
        },
      }
    end
  end
end
