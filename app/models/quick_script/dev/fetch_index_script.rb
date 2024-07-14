module QuickScript
  module Dev
    class FetchIndexScript < Base
      self.title = "重い生成処理対策"
      self.description = "特殊な重い処理を実行するパラメータをURLの付与しないようにして直リンクから実行を防ぐ仕組みを検証する"
      self.form_method = :get
      self.button_label = "実行"
      self.router_push_failed_then_fetch = true # hidden_on_query にした場合URLが変わらないためこちらも必要
      self.button_click_loading = true # 連打させたくない場合

      def form_parts
        super + [
          {
            :label           => "公開",
            :key             => :key1,
            :type            => :radio_button,
            :elems           => {"A" => "false", "B" => "true"},
            :default         => params[:key1].presence || "false",
          },
          {
            :label           => "非公開",
            :key             => :key2,
            :type            => :radio_button,
            :elems           => {"A" => "false", "B" => "true"},
            :default         => "false",   # 毎回元に戻したい場合
            :hidden_on_query => true,      # URLからも隠したい場合
          },
        ]
      end

      def call
        if fetch_index >= 1     # ロード時に実行させたくない場合
          if params[:key2] == "true"
            # 重い処理
          end
        end

        params
      end
    end
  end
end
