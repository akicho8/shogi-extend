url = "<%= current_record.sanmyaku_view_url %>"
if url == ""
  alert("混み合っているようです")
else
  location.href = url
