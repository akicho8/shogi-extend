require "./setup"
toolkit = GoogleApi::Toolkit.new
toolkit.json_content.present?   # => true
# spreadsheet = toolkit.spreadsheet_create
# spreadsheet.spreadsheet_id      # => "1TC6wdt2wwlqRW1zTVL0akPwvZlaH7FvDyvhnX4SNr1o"
