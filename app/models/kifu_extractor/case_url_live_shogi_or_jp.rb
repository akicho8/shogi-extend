# live.shogi.or.jp の下にある中継サイトはすべて同じルール
# rails r 'puts KifuExtractor.extract("http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.html")'
# rails r 'puts KifuExtractor.extract("http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.kif")'
#
# 棋王戦 http://live.shogi.or.jp/kiou/kifu/45/kiou202002010101.html
# 竜王戦 http://live.shogi.or.jp/ryuou/kifu/34/ryuou202110080101.html
# 叡王戦 http://live.shogi.or.jp/eiou/kifu/6/eiou202109130101.html
#
module KifuExtractor
  class CaseUrlLiveShogiOrJp < Extractor
    def resolve
      if uri = extracted_uri
        if uri.host.include?("live.shogi.or.jp")
          url = uri.to_s.sub(/html/, "kif")
          @body = human_very_dirty_kif_fetch_and_clean(url)
        end
      end
    end
  end
end
