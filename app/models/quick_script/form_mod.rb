module QuickScript
  concern :FormMod do
    prepended do
      class_attribute :form_method,                   default: nil    # :get か :post を指定するとボタンを表示する
      class_attribute :button_label,                  default: "実行" # ボタンを表示するとききのラベル名
      class_attribute :params_add_submit_key,         default: nil    # GETボタンのとき params に追加したいキー (URLにも入る)
      class_attribute :get_then_axios_get,            default: false  # GETボタンを押したとき axios だけで get するか？  (連打可能になる)
      class_attribute :router_push_failed_then_fetch, default: false  # URL引数に変化がなくてもGETボタンを作動させるか？
      class_attribute :button_click_loading,          default: false  # axios実行中にクルクル画面で連打を防止するか？
      class_attribute :form_before_call_check,        default: true   # form_parts を呼ぶより前に call を呼んでいること、のチェックをするか？
    end

    def as_json(*)
      hv = super

      if form_before_call_check
        unless @__performed_count__
          raise QuickScriptError, "form_parts を呼ぶ前に call が実行されていない"
        end
      end

      hv.merge({
          :form_method                   => form_method,
          :button_label                  => button_label,
          :params_add_submit_key         => params_add_submit_key,
          :get_then_axios_get            => get_then_axios_get,
          :router_push_failed_then_fetch => router_push_failed_then_fetch,
          :button_click_loading          => button_click_loading,
          :form_parts                    => form_parts,
        })
    end

    def form_parts
      []
    end

    def submitted?
      if params_add_submit_key
        params[params_add_submit_key].to_s == "true"
      end
    end
  end
end
