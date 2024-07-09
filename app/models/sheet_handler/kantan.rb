module SheetHandler
  class Kantan
    def call
      # ユーザーデータをスプレッドシートに書き込み
      rows = [
        ["ID", "Name", "Email"], # ヘッダー行
        [1, "alice", "alice@example.com"],
        [2, "bob", "bob@example.com"],
      ]

      service = GoogleSheet.new
      spreadsheet = service.create_spreadsheet("New Spreadsheet")
      spreadsheet_id = spreadsheet.spreadsheet_id
      url = "https://docs.google.com/spreadsheets/d/#{spreadsheet_id}/edit"
      puts url

      # 共有設定を変更
      service.share_spreadsheet(spreadsheet_id)

      row_count = rows.size
      column_count = rows.first.size

      # セル範囲を動的に設定
      range = "Sheet1!R1C1:R#{row_count}C#{column_count}"
      puts range

      service.update_spreadsheet(spreadsheet_id, range, rows)

      # row_count = 1
      # range = "Sheet1!R1C1:R#{row_count}C#{column_count}"

      # ヘッダー部分の範囲指定 (R1C1 形式)
      range = {
        sheet_id: 0,                    # シートの ID (通常は 0 から始まる)
        start_row_index: 0,             # 開始行 (0 から始まる)
        end_row_index: 1,               # 終了行 (0 から始まる、1 行目まで) ← 省略しても動いたけどちゃんと合わせたほうがよさそう
        start_column_index: 0,          # 開始列 (0 から始まる)
        end_column_index: column_count, # 終了列 (0 から始まる、A列からC列まで) ← 省略しても動いたけどちゃんと合わせたほうがよさそう
      }

      requests = [
        {
          update_cells: {
            range: range,
            fields: 'userEnteredFormat.backgroundColor',
            rows: [
              {
                values: Array.new(column_count, {
                    user_entered_format: {
                      background_color: {
                        red: 0.9,
                        green: 0.9,
                        blue: 0.9,
                      }
                    },
                  }),
              }
            ]
          }
        }
      ]

      # バッチ更新の実行
      service.cell_update(spreadsheet_id, requests)

      {
        :spreadsheet_id => spreadsheet_id,
        :url            => url,
      }
    end
  end
end
