# production 確認手順
#
#  cap production deploy:upload FILES=app/models/swars/rarity_info.rb,app/models/swars/distribution_ratio.rb
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
      # キーは直接使うべからず。無くても動くようにする
      { key: :rarity_key_SSR, name: "SSR", ratio: 0.0007266304469336195, style_key: :"変態",   segment: :minority, }, # 個数65個以下(つまりN個を含めたNの一番上)
      { key: :rarity_key_SR,  name: "SR",  ratio: 0.0034779486834281355, style_key: :"準変態", segment: :minority, }, # diff_from_avg が - になる最初
      { key: :rarity_key_R,   name: "R",   ratio: 0.011624015528435332,  style_key: :"準王道", segment: :majority, }, # 上位25件 index:N-1 の値
      { key: :rarity_key_N,   name: "N",   ratio: 1.0,                   style_key: :"王道",   segment: :majority, },
    ]

    class << self
      def lookup(v)
        super || invert_table[v.to_s]
      end

      private

      def invert_table
        @invert_table ||= inject({}) { |a, e| a.merge(e.name => e, e.style_key.to_s => e) }
      end
    end

    def style_info
      StyleInfo.fetch(style_key)
    end
  end
end
