module Swars
  module Agent
    class Record < Base
      def default_params
        super.merge({
          })
      end

      def fetch
        if params[:verbose]
          puts "[fetch][show] #{url_path}"
        end
        # if params[:dry_run]
        #   return IndexResult.empty
        # end
        html = fetcher.fetch("show", url_path)
        if !html || params[:SwarsBattleNotFound]
          raise SwarsBattleNotFound
        end
        md = html.match(/data-react-props="(.*?)"/)
        md or raise SwarsFormatIncompatible
        JSON.parse(CGI.unescapeHTML(md.captures.first))
      end

      private

      def url_path
        "/games/#{params[:key]}"
      end
    end
  end
end
