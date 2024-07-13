module QuickScript
  module Dev
    class SheetScript < Base
      self.title = "Google シート出力"
      self.description = "テーブルを Google スプレッドシートで出力する"
      self.form_method = :get
      self.params_add_submit_key = :exec
      self.get_then_axios_get = true
      self.button_click_loading = true

      def call
        if submitted?
          rows = [
            { "名前": "alice", "読み": "ありす",     },
            { "名前": "bob",   "読み": "ぼぶ",       },
            { "名前": "carol", "読み": "きゃろる",   },
          ]
          # rows = nil
          url = GoogleApi::Facade.new(source_rows: rows).call
          redirect_to url, tab_open: true
        end
      end
    end
  end
end
