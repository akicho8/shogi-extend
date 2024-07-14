# 想定する例外 rows が空のとき → /opt/rbenv/versions/3.2.2/lib/ruby/gems/3.2.0/gems/google-apis-core-0.15.0/lib/google/apis/core/http_command.rb:244:in `check_status': badRequest: Unable to parse range: Sheet1!R1C1:R0C0 (Google::Apis::ClientError)
# sheet_id の 0 は最初のシートという意味
# 参照 https://qiita.com/howdy39/items/c28c0328038d9c43f389
#
module GoogleApi
  class Facade
    def initialize(params = {})
      @params = params
      validate!
    end

    def call
      ExpirationTracker.create!(spreadsheet_id: spreadsheet_id)
      toolkit.spreadsheet_update(spreadsheet_id, data_range, rows) # 書き込み
      toolkit.spreadsheet_share(spreadsheet_id)                    # 共有権限に変更する
      decoration
      response
    end

    def decoration
      @requests = []
      header_grey_draw
      # cell_write_sample
      # cell_padding_set
      column_display_format_set
      # column_auto_resize # 正しく動作しない
      toolkit.cell_update(spreadsheet_id, @requests)
    end

    def validate!
      if source_rows.blank?
        # raise ArgumentError, "params[:source_rows] is blank"
      end
    end

    def response
      url
    end

    def header_grey_draw
      @requests << {
        repeat_cell: {
          range: {
            sheet_id: 0,        # 最初シート
            start_row_index: 0, # y = 0...1
            end_row_index: 1,
          },
          cell: {
            user_entered_format: {
              text_format: {
                bold: true
              },
              background_color: {
                red:   0.9,  # 背景色を灰色に設定
                green: 0.9,
                blue:  0.9,
              },
            }
          },
          fields: 'userEnteredFormat.backgroundColor,userEnteredFormat.textFormat.bold',
        },
      }
    end

    def column_auto_resize
      # @requests << {
      #   auto_resize_dimensions: {
      #     dimensions: {
      #       sheet_id: 0,
      #       dimension: 'COLUMNS',
      #       start_index: 0,
      #       end_index: row_count,
      #     }
      #   }
      # }

      @requests << {
        auto_resize_dimensions: {
          dimensions: {
            sheet_id: 0,  # シートID（通常は最初のシートは0）
            dimension: 'COLUMNS',  # 列を指定
            # start_index: 0,  # 最初の列から
            # end_indexを指定しないことで、すべての列が対象になります
            # start_index: 0,  # 最初の列から
            # end_index: 1,  # 最初の列から
          }
        }
      }

      # @requests << {
      #   auto_resize_dimensions: {
      #     dimensions: {
      #       sheet_id: 0,  # シートID（通常は最初のシートは0）
      #       dimension: 'COLUMNS',  # 列を指定
      #       # start_index: 0,  # 最初の列から
      #       # end_indexを指定しないことで、すべての列が対象になります
      #       start_index: 1,  # 最初の列から
      #       end_index: 2,  # 最初の列から
      #     }
      #   }
      # }

    end

    def cell_write_sample
      @requests += [
        {
          update_cells: {
            range: {
              :sheet_id           => 0,            # シートの ID (通常は 0 から始まる)
              :start_row_index    => 0,            # 開始行 (0 から始まる)
              :end_row_index      => 1,            # 終了行 (0 から始まる、1 行目まで) ← 省略しても動いたけどちゃんと合わせたほうがよさそう
              :start_column_index => 0,            # 開始列 (0 から始まる)
              :end_column_index   => 1,            # 終了列 (0 から始まる、A列からC列まで) ← 省略しても動いたけどちゃんと合わせたほうがよさそう
            },
            fields: '*',
            rows: [
              {
                values: [
                  {
                    user_entered_value: {
                      formula_value: '=HYPERLINK("https://example.com/", "foo")',
                    },
                  },
                ],
              },
            ]
          }
        }
      ]
    end

    def cell_padding_set
      @requests << {
        repeat_cell: {
          range: {
            sheet_id: 0,  # 最初のシート
          },
          cell: {
            user_entered_format: {
              padding: {
                top: 6,
                bottom: 6,
                left: 6,
                right: 6,
              }
            }
          },
          fields: 'userEnteredFormat.padding'
        }
      }
    end

    def column_display_format_set
      column_keys.each.with_index do |column_key, index|
        if column = columns_hash[column_key]
          @requests << {
            repeat_cell: {
              range: {
                sheet_id: 0,
                start_row_index: 0,           # Y 開始
                end_row_index: nil,           # Y 終了 (省略するとその列の一番下まで有効になる)
                start_column_index: index,    # X 開始
                end_column_index: index.next, # X 適用が終わる列なので +1
              },
              fields: "userEnteredFormat.numberFormat", # 更新するものを指定しないと他の情報が消える
              cell: {
                # user_entered_format: {
                #   number_format: {
                #     type: "PERCENT",
                #     pattern: "0.00 %",
                #   }
                # },
                user_entered_format: column,
              },
            },
          }
        end
      end
    end

    def toolkit
      @toolkit ||= Toolkit.new
    end

    def spreadsheet
      @spreadsheet ||= toolkit.spreadsheet_create(@params[:title] || "New Spreadsheet")
    end

    def spreadsheet_id
      @spreadsheet_id ||= spreadsheet.spreadsheet_id
    end

    def url
      "https://docs.google.com/spreadsheets/d/#{spreadsheet_id}/edit"
    end

    def source_rows
      @params[:source_rows]
    end

    def rows
      @rows ||= [column_keys] + source_rows.collect(&:values)
    end

    def column_keys
      @column_keys ||= source_rows.first.try { keys } || []
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

    def columns_hash
      @params[:columns_hash] || {}
    end
  end
end
