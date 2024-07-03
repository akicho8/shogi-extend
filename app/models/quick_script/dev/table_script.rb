module QuickScript
  module Dev
    class TableScript < Base
      self.title = "テーブル表示"

      def call
        [
          { "名前": "alice", "読み": "ありす",     },
          { "名前": "bob",   "読み": "ぼぶ",       },
          { "名前": "carol", "読み": "きゃろる",   },
        ]
      end
    end
  end
end
