url = "<%= current_record.mountain_url %>"
if url == ""
  Vue.prototype.$toast.open({message: "混み合っているようです", position: "is-bottom", type: "is-danger"})
else
  # location.href = url
  # window.open(url, "_blank")
