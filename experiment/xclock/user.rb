require "./setup"

tp User.sysop
User.sysop.avatar.attached? # => true
# >> |------------------------+--------------------------------------------------------------|
# >> |                     id | 14                                                           |
# >> |                    key | sysop                                                        |
# >> |                   name | 運営3                                                        |
# >> |              online_at |                                                              |
# >> |            fighting_at |                                                              |
# >> |            matching_at |                                                              |
# >> |          cpu_brain_key |                                                              |
# >> |             user_agent |                                                              |
# >> |               race_key | human                                                        |
# >> |             created_at | 2020-05-25 23:20:35 +0900                                    |
# >> |             updated_at | 2020-05-28 15:05:22 +0900                                    |
# >> |                  email | sysop@localhost                                              |
# >> |     encrypted_password | $2a$11$UI.HOHKoQ0.yuFGdtaTBEu9jPPU99boKnOL6AUJWLystWgIRwb/RC |
# >> |   reset_password_token |                                                              |
# >> | reset_password_sent_at |                                                              |
# >> |    remember_created_at |                                                              |
# >> |          sign_in_count | 2                                                            |
# >> |     current_sign_in_at | 2020-05-25 23:21:45 +0900                                    |
# >> |        last_sign_in_at | 2020-05-25 23:21:04 +0900                                    |
# >> |     current_sign_in_ip | 127.0.0.1                                                    |
# >> |        last_sign_in_ip | ::1                                                          |
# >> |     confirmation_token |                                                              |
# >> |           confirmed_at |                                                              |
# >> |   confirmation_sent_at |                                                              |
# >> |      unconfirmed_email |                                                              |
# >> |        failed_attempts | 0                                                            |
# >> |           unlock_token |                                                              |
# >> |              locked_at |                                                              |
# >> |              joined_at | 2020-05-25 23:20:35 +0900                                    |
# >> |------------------------+--------------------------------------------------------------|
