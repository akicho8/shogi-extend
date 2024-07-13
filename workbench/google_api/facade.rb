require "./setup"
facade = GoogleApi::Facade.new(rows: [{id: 1}])
facade.rows               # => [[:id], [1]]
facade.call               # => {:spreadsheet_id=>"1aYfCL5FyDk8voqkLCNkpGhen6kwNDxfyKVZOHwBsye0", :url=>"https://docs.google.com/spreadsheets/d/1aYfCL5FyDk8voqkLCNkpGhen6kwNDxfyKVZOHwBsye0/edit"}
