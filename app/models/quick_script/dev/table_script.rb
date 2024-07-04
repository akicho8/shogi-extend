module QuickScript
  module Dev
    class TableScript < Base
      self.title = "テーブル表示"
      self.description = "ハッシュの配列を返したときの表示を行う"

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
