# 間違えて入力された得体の知れないURLは巨大なHTMLになっていることが多いため
# タグを取ったり文字コードを安全にしたりして死なないようにする
# rails r 'puts KifuExtractor.extract("https://www.shogi-extend.com/")'
# rails r 'puts KifuExtractor.extract("https://lishogi.org/")'
module KifuExtractor
  class CaseUrlUnknown < Base
    def resolve
      if v = uri_fetched_content
        v = v.toutf8
        v = StringSupport.strip_tags(v)
        v = v.strip
        if v.present?
          if Bioshogi::Parser.accepted_class(v)
            if legal_valid?(v)
              @body = v
            end
          end
        end
      end
    end
  end
end
