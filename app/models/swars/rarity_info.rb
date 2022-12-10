module Swars
  class RarityInfo
    include ApplicationMemoryRecord
    memory_record [
      # 順番は希少なものが先
      { key: :super_special_rare, name: "SSR", ratio: 0.0012628842046615285, name_in_player_info: "超レア", },
      { key: :super_rare,         name: "SR",  ratio: 0.0036215061751323245, name_in_player_info: "レア",   }, # 平均より上の最後の値
      { key: :rare,               name: "R",   ratio: 0.011328814188875476,  name_in_player_info: "準王道", },
      { key: :normal,             name: "N",   ratio: 1.0,                   name_in_player_info: "王道",   },
    ]

    class << self
      def lookup(v)
        super || invert_table[v]
      end

      private

      def invert_table
        @invert_table ||= inject({}) {|a, e| a.merge(e.name => e) }
      end
    end
  end
end
