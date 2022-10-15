# パラメータから取り出す
# rails r 'puts KifuExtractor.extract("https://example.com/?body=68S")'
# rails r 'puts KifuExtractor.extract("https://example.com/?sfen=68S")'
# rails r 'puts KifuExtractor.extract("https://example.com/#68S")'
module KifuExtractor
  class CaseUrlParams < Extractor
    LOOKUP_PARAM_KEYS = [:text, :content, :contents, :body]

    def resolve
      if uri = extracted_uri
        if uri.query || uri.fragment
          params = params_collect
          if s = params["xbody"]
            @body = SafeSfen.decode(s) # xbody の場合はすべてのチェックを省くので速い
          else
            all_lookup_param_keys.each do |key|
              if s = params[key]
                s = DotSfen.unescape(s)
                p [key, s, Bioshogi::Parser.accepted_class(s)]
                if s.present?
                  if Bioshogi::Parser.accepted_class(s)
                    if legal_valid?(s)
                      @body = s
                      break
                    end
                  end
                end
              end
            end
          end
        end
      end
    end

    private

    def params_collect
      {}.tap do |hv|
        uri = extracted_uri
        if uri.query
          hv.update(Rack::Utils.parse_query(uri.query))
        end
        if uri.fragment
          hv.update("__fragment__" => Rack::Utils.unescape(uri.fragment))
        end
      end
    end

    def all_lookup_param_keys
      [*Item::BASIC_EXTENTIONS, *LOOKUP_PARAM_KEYS, "__fragment__"].collect(&:to_s)
    end
  end
end
