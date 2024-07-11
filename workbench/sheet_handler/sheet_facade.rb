require "./setup"
sheet_facade = SheetHandler::SheetFacade.new(rows: [{id: 1}])
sheet_facade.rows               # => [[:id], [1]]
sheet_facade.call               # => {:spreadsheet_id=>"1aYfCL5FyDk8voqkLCNkpGhen6kwNDxfyKVZOHwBsye0", :url=>"https://docs.google.com/spreadsheets/d/1aYfCL5FyDk8voqkLCNkpGhen6kwNDxfyKVZOHwBsye0/edit"}
