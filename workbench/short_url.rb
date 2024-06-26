require File.expand_path('../../config/environment', __FILE__)

Rails.application.routes.default_url_options # => {:host=>"localhost", :port=>3000}

tp ShortUrl

response = Faraday.post("http://localhost:3000/url.json", :original_url => "abc")
p response.status
attributes = JSON.parse(response.body)
tp attributes
# >> |----+----------------------------------+--------------------------+---------------------------+---------------------------|
# >> | id | key                              | original_url             | created_at                | updated_at                |
# >> |----+----------------------------------+--------------------------+---------------------------+---------------------------|
# >> |  1 | acbd18db4cc2f85cedef654fccc4a4d8 | foo                      | 2023-11-22 20:42:26 +0900 | 2023-11-22 20:42:26 +0900 |
# >> |  2 | 9d0f4061beb6ae41f64eb124665e0768 | http://www.google.co.jp/ | 2023-11-22 20:42:49 +0900 | 2023-11-22 20:42:49 +0900 |
# >> |  3 | aae1cf3cb358fab3f0685775655dc000 | http://localhost:3000/   | 2023-11-22 20:43:29 +0900 | 2023-11-22 20:43:29 +0900 |
# >> |  4 | 0cc175b9c0f1b6a831c399e269772661 | a                        | 2023-11-22 21:09:15 +0900 | 2023-11-22 21:09:15 +0900 |
# >> |----+----------------------------------+--------------------------+---------------------------+---------------------------|
# >> 200
# >> |--------------+----------------------------------|
# >> |           id | 5                                |
# >> |          key | 900150983cd24fb0d6963f7d28e17f72 |
# >> | original_url | abc                              |
# >> |   created_at | 2023-11-22T21:09:38.000+09:00    |
# >> |   updated_at | 2023-11-22T21:09:38.000+09:00    |
# >> |--------------+----------------------------------|
