# 拡張子まで指定されていたら信じるしかなかろう
# rails r 'puts KifuExtractor.extract("https://www.shogi-extend.com/example_shift_jis.kif")'
module KifuExtractor
  class CaseUrlTrustworthyFile < Extractor
    def resolve
      if url = extracted_kif_url
        if v = url_fetched_content
          @body = v.toutf8
        end
      end
    end
  end
end
