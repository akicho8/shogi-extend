require "./setup"
facade = GoogleApi::Facade.new(source_rows: [{id: 1}])
facade.rows               # => [[:id], [1]]
facade.call               # => "https://docs.google.com/spreadsheets/d/1GO77eKxppcyKRotIxMETOitkSLta4gGQ3kYaraFVSY4/edit"
