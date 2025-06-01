module QuickScript
  module Middleware
    concern :GeneralApiMod do
      prepended do
        class_attribute :json_link, default: false # JSON のリンクを表示するか？
      end

      # このなかで params[:json_type} == "general" なら as_general_json を返す、としたのは設計ミスだった。
      # なぜなら、as_json は中身が Nuxt 側のビュー用のパラメータ(Hash)を返すと想定しているので、
      # as_json で as_general_json の内容(配列)を返してしまうと、続くモジュールが super.merge としてエラーになる。
      # また as_general_json で Hash を返してしまうと、エラーがでることもなく Nuxt 用のパラメータがまざってします。
      # したがって render_format のなかで分岐するのが正しい。
      #
      # json_link を定義するのではなく
      # 単に respond_to?(:as_general_json) なら json_link: true でいいような気もする
      def as_json(*)
        super.merge(json_link: json_link)
      end

      def render_format(format)
        if params[:json_type] == "general"
          if respond_to?(:as_general_json)
            format.json { controller.render json: as_general_json, status: status_code }
            return
          end
        end

        super
      end
    end
  end
end
