require "./setup"

rows = []
Wkbk::Question.all.each do |e|
  row = {}
  row[:id] = e.id
  row[:updated_at] = e.updated_at.strftime("%F %T")
  if e.created_at < Time.zone.parse("2020-07-29 19:15")
    rows << row
  end
end

pp rows

