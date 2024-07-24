require "./setup"
QuickScript::Tool::ShortUrlScript.new(_method: :post, original_url: "http://localhost:3000/").call # => {:_autolink=>"http://localhost:3000/u/zZSGrCkrLPo"}
