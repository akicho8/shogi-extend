require "./setup"

AuthInfo.count                  # => 2
tp AuthInfo
AuthInfo.last.app_logging
AuthInfo.first.name             # => "Github"

# User.count                      # => 5
# count = AuthInfo.count
# success = 0
# error = 0
# AuthInfo.find_each do |record|
#   src = record.meta_info_before_type_cast
#   if src.kind_of?(String)
#     record.meta_info = Psych.load(src).as_json
#     record.save!(validate: false)
#     record.reload
#   end
#   if record.meta_info.kind_of?(Hash)
#     success += 1
#   else
#     error += 1
#   end
#   count -= 1
#   p [count, success, error]
# end
# >> |-------+---------+----------+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> | id    | user_id | provider | uid                   | meta_info                                                                                                                                                                                                                                                           |
# >> |-------+---------+----------+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> | 10966 |      33 | github   |                808955 | {"provider"=>"github", "uid"=>"808955", "info"=>{"nickname"=>"akicho8", "email"=>"akicho8@gmail.com", "name"=>"Akira Ikeda", "image"=>"https://avatars.githubusercontent.com/u/808955?v=4", "urls"=>{"GitHub"=>"https://github.com/akicho8", "Blog"=>""}}, "cred... |
# >> | 10970 |      51 | google   | 101367992961344409174 | {"provider"=>"google", "uid"=>"101367992961344409174", "info"=>{"name"=>"Akira Ikeda", "email"=>"pinpon.ikeda@gmail.com", "unverified_email"=>"pinpon.ikeda@gmail.com", "email_verified"=>true, "first_name"=>"Akira", "last_name"=>"Ikeda", "image"=>"https://l... |
# >> |-------+---------+----------+-----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> 2024-07-24T08:03:32.641Z pid=57440 tid=1crg INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
