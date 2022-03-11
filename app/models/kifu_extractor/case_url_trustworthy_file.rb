# 拡張子まで指定されていたら信じるしかなかろう
# rails r 'puts KifuExtractor.extract("https://www.shogi-extend.com/example_shift_jis.kif")'
module KifuExtractor
  class CaseUrlTrustworthyFile < Extractor
    def resolve
      if uri = extracted_kif_uri
        if v = uri_fetched_content
          @body = v.toutf8
        end
      end
    end
  end
end
