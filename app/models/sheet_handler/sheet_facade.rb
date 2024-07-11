# 想定する例外
# ・rows が空のとき → /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/google-apis-core-0.15.0/lib/google/apis/core/http_command.rb:244:in `check_status': badRequest: Unable to parse range: Sheet1!R1C1:R0C0 (Google::Apis::ClientError)

module SheetHandler
  class SheetFacade
    def initialize(params = {})
      @params = params
      validate!
    end

    def call
      google_sheet.spreadsheet_update(spreadsheet_id, data_range, rows) # 書き込み
      google_sheet.spreadsheet_share(spreadsheet_id)                    # 共有権限に変更する
      response
    end

    def validate!
      if @params[:rows].blank?
        # raise ArgumentError, "params[:rows] is blank"
      end
    end

    def response
      {
        :spreadsheet_id => spreadsheet_id,
        :url            => url,
      }
    end

    def color_draw
      # ヘッダー部分の範囲指定 (R1C1 形式)
      range = {
        :sheet_id           => 0,            # シートの ID (通常は 0 から始まる)
        :start_row_index    => 0,            # 開始行 (0 から始まる)
        :end_row_index      => 1,            # 終了行 (0 から始まる、1 行目まで) ← 省略しても動いたけどちゃんと合わせたほうがよさそう
        :start_column_index => 0,            # 開始列 (0 から始まる)
        :end_column_index   => column_count, # 終了列 (0 から始まる、A列からC列まで) ← 省略しても動いたけどちゃんと合わせたほうがよさそう
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
      google_sheet.cell_update(spreadsheet_id, requests)
    end

    def google_sheet
      @google_sheet ||= GoogleSheet.new
    end

    def spreadsheet
      @spreadsheet ||= google_sheet.spreadsheet_create("New Spreadsheet")
    end

    def spreadsheet_id
      @spreadsheet_id ||= spreadsheet.spreadsheet_id
    end

    def url
      "https://docs.google.com/spreadsheets/d/#{spreadsheet_id}/edit"
    end

    def rows
      @rows ||= (@params[:rows] || []).take(1).collect(&:keys) + (@params[:rows] || []).collect(&:values)
    end

    def data_range
      "Sheet1!R1C1:R#{row_count}C#{column_count}"
    end

    def row_count
      rows.size
    end

    def column_count
      if row = rows.first
        row.size
      else
        0
      end
    end
  end
end
