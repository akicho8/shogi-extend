# |-----------------------------------+--------------------------------------------|
# | Code                              | 意味                                       |
# |-----------------------------------+--------------------------------------------|
# | self.title_link = :url_path_reset | パスを空にして現在のURLに移動する (初期値) |
# | self.title_link = :force_reload   | 現在のURLで強制的にブラウザリロードする    |
# | self.title_link = nil             | 何もしない                                 |
# |-----------------------------------+--------------------------------------------|

module QuickScript
  module Middleware
    concern :TitleLinkMod do
      prepended do
        class_attribute :title_link, default: :url_path_reset
      end

      def as_json(*)
        super.merge(title_link: title_link)
      end
    end
  end
end
