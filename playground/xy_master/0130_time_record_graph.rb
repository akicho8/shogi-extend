require "./setup"

scope = TimeRecord.all
scope = scope.where(rule_key: "rule100")
scope.group("entry_name").order("count_all desc").having("count_all >= 10").count # => {}

names = scope.group("entry_name").pluck("entry_name") # => []
result = TimeRecord.select("entry_name, date(created_at) as created_on, min(spent_sec) as spent_sec").where(rule_key: "rule100").group("entry_name, date(created_at)")
rows = names.collect { |name|
  v = result.find_all { |e| e.entry_name == name }
  unless v.empty?
    {
      name: name,
      data: v.collect { |e| {x: e.created_on, y: e.spent_sec } }.as_json,
    }
  end
}.compact
tp rows

# puts v.to_json
