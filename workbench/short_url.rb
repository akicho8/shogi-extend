require "./setup"
ShortUrl["xxx"]                   # => "http://localhost:3000/u/zC3CzFn5jev"
ShortUrl.transform("xxx")         # => "http://localhost:3000/u/zC3CzFn5jev"
ShortUrl.from("xxx")              # => #<ShortUrl::Component id: 10, key: "zC3CzFn5jev", original_url: "xxx", access_logs_count: 0, created_at: "2024-07-20 08:36:08.000000000 +0900", updated_at: "2024-07-20 08:36:08.000000000 +0900">
ShortUrl.key("xxx")               # => "zC3CzFn5jev"
