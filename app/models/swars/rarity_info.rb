# production 確認手順
#
#  cap production deploy:upload FILES=app/models/swars/rarity_info.rb
#  cap production puma:restart
#  cap production rails:runner CODE="Rails.cache.clear"
#  open https://www.shogi-extend.com/api/swars/distribution_ratio
#  cd ~/src/bioshogi
#  rake generate
#
module Swars
  class RarityInfo
    include ApplicationMemoryRecord
    memory_record [
      # 順番は希少なものが先
      { key: :super_special_rare, name: "SSR", ratio: 0.00005609594650690541, name_in_player_info: "変態",   }, # 個数5個以下
      { key: :super_rare,         name: "SR",  ratio: 0.0034779486834281355,  name_in_player_info: "準変態", }, # diff_from_avg が - になる最初
      { key: :rare,               name: "R",   ratio: 0.01057969551120236,    name_in_player_info: "準王道", }, # 上位25件 index:24 の値
      { key: :normal,             name: "N",   ratio: 1.0,                    name_in_player_info: "王道",   },
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
