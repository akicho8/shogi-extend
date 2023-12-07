module Swars
  module Agent
    class Record < Base
      def fetch
        if params[:verbose]
          puts "[fetch][record] #{key.to_battle_url}"
        end
        html = fetcher.fetch(:record, key.to_battle_url)
        if !html || params[:SwarsBattleNotFound]
          raise SwarsBattleNotFound.new("指定の対局が存在しません<br>URLを間違えていませんか？<br>#{key.to_battle_url}")
        end
        md = html.match(/data-react-props="(.*?)"/)
        if !md || params[:SwarsFormatIncompatible]
          raise SwarsFormatIncompatible
        end
        JSON.parse(CGI.unescapeHTML(md.captures.first))
      end

      private

      def key
        params.fetch(:key)
      end
    end
  end
end
