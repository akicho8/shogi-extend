module QuickScript
  concern :FormMod do
    prepended do
      class_attribute :form_method,                   default: nil    # :get か :post を指定するとボタンを表示する
      class_attribute :button_label,                  default: "実行" # ボタンを表示するとききのラベル名
      class_attribute :params_add_submit_key,         default: nil    # GETボタンのとき params に追加したいキー
      class_attribute :get_then_router_push,          default: false  # GETボタンを押したとき $router.push するか？(すると params_add_submit_key があるとき URL が変わるのと、router_push_failed_then_fetch に関係なく API を叩く)
      class_attribute :router_push_failed_then_fetch, default: false  # URL引数に変化がなくてもGETボタンを作動させるか？
    end

    def as_json(*)
      super.merge({
          :form_method                   => form_method,
          :button_label                  => button_label,
          :params_add_submit_key         => params_add_submit_key,
          :form_parts                    => form_parts,
          :router_push_failed_then_fetch => router_push_failed_then_fetch,
        })
    end

    private

    def form_parts
      []
    end

    def submitted?
      if params_add_submit_key
        params[params_add_submit_key] == "true"
      end
    end
  end
end
