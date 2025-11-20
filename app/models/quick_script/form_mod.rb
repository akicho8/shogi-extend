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
          # raise QuickScriptError, "form_parts を呼ぶ前に call が実行されていない"
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
            raise "#{self.class.name} の #{form_part[:key]} の #{column_key} をブロックにしよう"
          end
          form_part = form_part.merge(v.call, dynamic_part: nil)
        end
        form_part.merge(elems: elsms_normalize(form_part[:elems]))
      end
    end

    # elsms_normalize(nil)                                                                                              # => {} }
    # elsms_normalize("a")                                                                                              # => {:a=>{:el_label=>"a", :el_message=>nil}} }
    # elsms_normalize([1, 2])                                                                                           # => {:"1"=>{:el_label=>"1", :el_message=>nil}, :"2"=>{:el_label=>"2", :el_message=>nil}}
    # elsms_normalize([["a", "A"], ["b", "B"]])                                                                         # => {:a=>{:el_label=>"A", :el_message=>nil}, :b=>{:el_label=>"B", :el_message=>nil}}
    # elsms_normalize(["a", "b"])                                                                                       # => {:a=>{:el_label=>"a", :el_message=>nil}, :b=>{:el_label=>"b", :el_message=>nil}}
    # elsms_normalize({ "a" => "A", "b" => "B" })                                                                       # => {:a=>{:el_label=>"A", :el_message=>nil}, :b=>{:el_label=>"B", :el_message=>nil}}
    # elsms_normalize({ "a" => { el_label: "A", el_message: "am" }, "b" => { el_label: "B", el_message: "bm" }, })      # => {:a=>{:el_label=>"A", :el_message=>"am"}, :b=>{:el_label=>"B", :el_message=>"bm"}}
    # elsms_normalize([ { key: "a", el_label: "A", el_message: "am" }, { key: "b", el_label: "B", el_message: "bm" } ]) # => {:a=>{:el_label=>"A", :el_message=>"am"}, :b=>{:el_label=>"B", :el_message=>"bm"}}
    def elsms_normalize(elems)
      # nil => []
      # "a" => ["a"]
      unless elems.kind_of?(Hash)
        elems = Array.wrap(elems)
      end

      hv = {}
      elems.each do |key, value|
        if key.kind_of?(Hash)
          value = key
          key = value[:key]
          value = value.except(:key)
        elsif !value.kind_of?(Hash)
          value = { el_label: value || key.to_s, el_message: nil }
        end
        hv[key.to_s.to_sym] = value
      end
      hv
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
