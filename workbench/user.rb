require "./setup"

# confirmed_at と一緒に email を指定すると変な email も保存できる
user = User.create!
user.email                      # => "fac0c48d55cbf54f17d8ff0b0477cc8d@localhost"

# そこでメールアドレスを変更するが、普通に変更してしまうと
user.email = "pinpon.ikeda+test1@gmail.com"
user.save!

# 更新されずそのかわり、confirmation_token にトークンが入る (メールも飛ぶ)
user.email                      # => "fac0c48d55cbf54f17d8ff0b0477cc8d@localhost"
user.confirmation_token         # => "susr6ZgycpiN4VQbLH2h"

# もし強制的に更新するのはむつかしい？？？

tp user
# >> |------------------------+--------------------------------------------------------------|
# >> |                     id | 47                                                           |
# >> |                    key | fac0c48d55cbf54f17d8ff0b0477cc8d                             |
# >> |                   name |                                                              |
# >> |               race_key | human                                                        |
# >> |          name_input_at |                                                              |
# >> |             created_at | 2024-07-20 15:16:58 +0900                                    |
# >> |             updated_at | 2024-07-20 15:17:02 +0900                                    |
# >> |                  email | fac0c48d55cbf54f17d8ff0b0477cc8d@localhost                   |
# >> |     encrypted_password | $2a$11$jL9Y6ctOPBb/tJEj0HmKG.Vz.jLaepdYo5exhXwWVnkQpgsR7QlVK |
# >> |   reset_password_token |                                                              |
# >> | reset_password_sent_at |                                                              |
# >> |    remember_created_at |                                                              |
# >> |          sign_in_count | 0                                                            |
# >> |     current_sign_in_at |                                                              |
# >> |        last_sign_in_at |                                                              |
# >> |     current_sign_in_ip |                                                              |
# >> |        last_sign_in_ip |                                                              |
# >> |     confirmation_token | xAPz5CyRs1-JRvGjPEum                                         |
# >> |           confirmed_at | 2024-07-20 15:17:02 +0900                                    |
# >> |   confirmation_sent_at | 2024-07-20 15:17:02 +0900                                    |
# >> |      unconfirmed_email | pinpon.ikeda+test2@gmail.com                                 |
# >> |        failed_attempts | 0                                                            |
# >> |           unlock_token |                                                              |
# >> |              locked_at |                                                              |
# >> |        permit_tag_list |                                                              |
# >> |------------------------+--------------------------------------------------------------|
