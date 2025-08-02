# |-----------------------------------+--------------------------------------------|
# | Code                              | 意味                                       |
# |-----------------------------------+--------------------------------------------|
# | self.title_click_behaviour = :url_params_remove | パスを空にして現在のURLに移動する (初期値) |
# | self.title_click_behaviour = :force_reload   | 現在のURLで強制的にブラウザリロードする    |
# | self.title_click_behaviour = nil             | 何もしない                                 |
# |-----------------------------------+--------------------------------------------|

module QuickScript
  module Middleware
    concern :TitleLinkMod do
      prepended do
        class_attribute :title_click_behaviour, default: :url_params_remove
      end

      def as_json(*)
        super.merge(title_click_behaviour: title_click_behaviour)
      end
    end
  end
end
