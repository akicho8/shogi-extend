url = "<%= current_record.mountain_url %>"
if url == ""
  alert("混み合っているようです")
else
  location.href = url
