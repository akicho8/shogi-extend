module Swars
  module Importer
    class CompleteImporter < FullHistoryImporter
      def default_params
        {
          :hard_crawl        => true,                            # 1ページ内の対局がすべて登録済みでも次を捲る
          :look_up_to_page_x => Rails.env.production? ? 100 : 1, # どこまで捲るか？
        }
      end
    end
  end
end
