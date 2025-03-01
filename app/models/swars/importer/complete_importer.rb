module Swars
  module Importer
    class CompleteImporter < FullHistoryImporter
      def default_params
        {
          :eager_to_next_page => true,                            # 1ページ内の対局がすべて登録済みでも次を捲る
          :look_up_to_page_x  => Rails.env.production? ? 100 : 2, # どこまで捲るか？
        }
      end
    end
  end
end
