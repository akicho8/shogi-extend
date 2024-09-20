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
        unless @__performed__
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
          :form_parts                    => form_parts_as_json,
        })
    end

    def form_parts
      []
    end

    def form_parts_as_json
      form_parts.collect do |form_part|
        rest = form_part.keys - [:key, :type, :label, :dynamic_part, :session_sync, :ls_sync]
        if rest.present?
          raise "#{self.class.name} の #{form_part[:key]} の #{rest} を dynamic_part の中に入れてください"
        end
        if v = form_part[:dynamic_part]
          unless v.kind_of?(Proc)
            raise "#{self.class.name} の #{form_part[:key]} の #{column_key} をブロックにしてください"
          end
          form_part = form_part.merge(v.call, dynamic_part: nil)
        end
        form_part
      end
    end

    def submitted?
      if params_add_submit_key
        params[params_add_submit_key].to_s == "true"
      end
    end

    # :PARAMS_SERIALIZE_DESERIALIZE:
    #
    # 文字列が配列風であれば配列化する "[a,b]" => ["a", "b"]
    # つまり空配列を x=[] と表現できる
    #
    # また空文字列は x="" とする
    #
    # もともと form_part[:type] を見ていたが、たんに文字列を見るようにすれば form_part に依存しなくなると考えたものの
    # params[form_part[:key]] としないとパラメータが取れないため、form_part に依存してしまう
    # したがって form_parts 内で params にアクセスしているところはすべて実行されないように proc 化する必要がある
    def params_deserialize(params)
      super.dup.tap do |params|
        form_parts.each do |e|
          key = e[:key]
          if v = params[key]
            if v.kind_of?(String)
              case
              when v == "__empty__"
                params[key] = ""
              when v == %("") || v == %('')
                params[key] = ""
              when md = v.match(/\A\[(?<array>.*)\]\z/)
                params[key] = md[:array].split(/,/)
              end
            end
          end
        end
      end
    end
  end
end
