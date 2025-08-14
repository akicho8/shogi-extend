require "./setup"
GoogleApi::JsonToYaml.new.call

Rails.application.credentials.dig(:google_api, :development).to_s.size # => 2358
Rails.application.credentials.dig(:google_api, :test).to_s.size        # => 2358
Rails.application.credentials.dig(:google_api, :production).to_s.size  # => 2331
Rails.application.credentials.dig(:google_api, :staging).to_s.size     # => 2331

tp Rails.application.credentials.dig(:google_api, :development)
tp Rails.application.credentials.dig(:google_api, :test)
tp Rails.application.credentials.dig(:google_api, :production)
tp Rails.application.credentials.dig(:google_api, :staging)
# >> ---
# >> type: service_account
# >> project_id: shogi-web-development
# >> private_key_id: 2792594c71a6dbc44224c0f666f6fe16ba5d0dab
# >> private_key: |
# >>   -----BEGIN PRIVATE KEY-----
# >>   MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCgpJfxqVXZ+xeC
# >>   vyLY/R+OO8j2tmxyXerxkIQh2h6CvqQW3NupzYI/H0Vq0pkUVrdkqMmKZi09XnvE
# >>   4Jbtk/uS2C/C6Wj1jm6BuaoHEynbO0O4Q7WFa/X9USQDKDSYRj2y7lGC5qC2C1Fn
# >>   Itk/TiYun3k8kH0SEJ+TESF9A/AAFnhNrLt8NU8O6BgXErXKpvx4QntqORrq1GQF
# >>   +D3ckhsVyze5Gh1rjK7xx02bCnWVPIRFQSQKSf0NxxHsBJw910tkrz7gXL3uG486
# >>   tJE/s6EvN2B/SqsZijcxmP5Uw6uWenkPgmHmuLQZD1YQKAePglQYY3xm0UAiAdUL
# >>   BsUtUHB5AgMBAAECggEAHkjJSEq3H6ABf6mO5T9a6pKEwVYEvc7M0vt+nW8kX1uX
# >>   TaQXWTyf+Exp5siLCVWLv1M+o3O9xZsBVE1Oxr0mKTnOTz13hwtx88zPrAPF2Umj
# >>   66IAH4YJ2taoJlw3Bhn/2bKp9TaLR6Z8kyfzssaF1jZEQdGvcm9l1fDd0laisTE+
# >>   uWcW+yXH+ABMnaNfAu3bRiRWkXRCafEvhw5ZScn5NE2QH8r3QQK/h+jwTfKIPYNO
# >>   kWN5qhJx6G6BlUB+LNkq50nDnsi0y8drslIswdpGFuGUMr7rFcAmCEzOnq99Mooc
# >>   6d8zsyV2YobO9IsM4zphXkuuMpjdt8lUPORX+z7+sQKBgQDS8t4ueVzmZ0x3xj90
# >>   9WiX4H98mBDttty8IztQlRfXOXa1ffOW47kNVetSNkr9i3niMCPWLbUrTbrE1Ygh
# >>   Ndsk9qMhPJnZD1EejpcYfNek0/jDMrBoXYzApWRjoxXyKUIa8ZV3IHNGsy2344q3
# >>   in+euXOTeAxJ/a/Th3NYEyFq5QKBgQDC81/quXAkPZjWQIoONPl5Czk7VCOpiqtv
# >>   xRxGWmkb2Au634XxGImgrvl2bvIbBgTvxPec22XjXXO3U3xDuLOnnKIx+ckT0AM+
# >>   2GBgSjQ8JrRjJrPf4maaR+9rsKk6/Y0/4t67hl3DQ2tbWAYGOoaUyNExLcdWel75
# >>   8ksdYPxSBQKBgFQ+tCbBRy2o4WwQG3WdMIk/GgrrPA+DcQId2+lhsaS9iUAQLgD7
# >>   rwK5ZoJttmMtmZ6QdS9rD6hcoZNMZ9JDjOJlMV7rsdFzAYV/kq4v5XspQHbMPpFf
# >>   kv+4za/RCMmuWn0iL/vkVMVOd5qx38tPH4qHK7YgQmAmVVrYBGOPOFBVAoGBAMLl
# >>   qtuv/iPNDPINXbesUEgp51Kf4HNL9e5swcK3+mLiz39IndCVtmnU5AL6EcLgdqj6
# >>   Yo4HbUosEFaT+SR/D+SenCyYSuUqzUPT8C3zoVsNWsPRWnyWC/trtTkVSWp3N/JJ
# >>   rmENiMmAqmCMlKE/e3JdfX3MBYA4IKGDEINThY29AoGBAM4LicLBitDxjpwj7zBD
# >>   8kMngQA0o7Zbus4vnfoOuCcfmbW8+4NaXwsqVToNWgCUfh44CrKMaJmk5rIU0kIy
# >>   iFiXQ5Yaey6eh+HntHzodDU9RBd5T1Xq99hvVvk2oE06Zo13G7Wy2/BI7AshjEsS
# >>   +8VVU+KDbSbUJmGWytFiO4Os
# >>   -----END PRIVATE KEY-----
# >> client_email: shogi-extend-development@shogi-web-development.iam.gserviceaccount.com
# >> client_id: '108798259944174897359'
# >> auth_uri: https://accounts.google.com/o/oauth2/auth
# >> token_uri: https://oauth2.googleapis.com/token
# >> auth_provider_x509_cert_url: https://www.googleapis.com/oauth2/v1/certs
# >> client_x509_cert_url: https://www.googleapis.com/robot/v1/metadata/x509/shogi-extend-development%40shogi-web-development.iam.gserviceaccount.com
# >> universe_domain: googleapis.com
# >> ---
# >> type: service_account
# >> project_id: shogi-web-production
# >> private_key_id: 39fc60ffd0a48d9f488fe42e19e5f04235d8568d
# >> private_key: |
# >>   -----BEGIN PRIVATE KEY-----
# >>   MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCn9QkBZPyoralY
# >>   LBRXgQgajPTTle6XwKk+WIkoj5zT+vc52arzuU7zmDynP4pEoKYNIPYe9GW+HK+c
# >>   bu3U0Cxkvo9qQtmAuxDGNZtN23h8vN/NYXGxFgAnmHukgVZvyDQ8MNDusK0jpmoF
# >>   pIWL6kNBFdTvhlRx6G8dnjZNcBr//CcZnl0NVpNM6Sd9qG3SCXIQtBJxOAfypjUQ
# >>   p50Xkb9r7rzHH7DTA59x7bGW95wHpxG30yU6B3bfPrf/wGp4ElbQgmy9s0bT/ALg
# >>   ZvtVnS/0xrrXKndT8GYzQvFfo6o+b6On+B7HP0YCk8mJOyp53DHgN2tC145u5J8m
# >>   wdxh/Tb/AgMBAAECggEABH2MdkE/xgy6jyptMs0MLUA2gs+qjNvFn+6YYCwSxSdx
# >>   Dla6TNYtUl2axYfxMkDZ9QDmw6YaGu6ZErAejgbbdlK9R9nYsdSOhWtv0bGRSO3N
# >>   zVJnypRsKvgshMCWfITtl0G2MaN/RYmQomz8dboCKU55nnEeIdt/2QVerfcA1HYw
# >>   x6RKLvhnvMwSD/R04gy6aXUSp6VHczjpgqzYnt97ghVbujM1uII99iOtu6WMSOvO
# >>   fDdzuIIMvMkbn7f9Lzq9ajf7laxg9Mr+wpn0jh6jLI2H0Q47GY+kb+FFEsLoXjOr
# >>   /OShLD2ispSZ6AxeIwh++jLFE/TjCDGYJvmbrwuRXQKBgQDVwfyr8MXW3y09PiKi
# >>   PkL/MkbzsPUk8z2eZCenfp0gc4ECO/unYGAjq10PrnZL+oueEi9qpnAPGU5kKjzw
# >>   xjLL4fJmJdgRTgLQMZfhNNNVvLZvB+PXnMJED7r5lbNiFayUCukWLyabSbMqL8Dj
# >>   aw3dV6PkmduuvMWXTT6Ap2gFgwKBgQDJJf6XYived0JHaRxtunPOxBrxscg9+Nqd
# >>   HTEkLENKnA+qMhMf6n+q9eHo5FlKPGIVL9bsYTgDAmAvFvO47SE4VwrhQ9O25f7p
# >>   pAOzhvXu46691PeO996H5cWImTcl7isJGjRnBWknwZ/Z6mwaSose1gAEZh8o6Cla
# >>   grBV3LwL1QKBgQCABBJfou3JFpWQVPMG+YTEMwcdEMBv5aDkiBTbkc9mTOZZQTUg
# >>   c26ATjOInbJJJH6TJ07wb0czM7On90fR5tErG2FBXa6+BltW9iyAelOKyF71teL1
# >>   EPOjMUyIBuiMeHCHpNUdLRXQ8F11iW3ahRWjlsYXtTFEv9cSGvewsxFwIwKBgDOk
# >>   l5rST6UMRW4EJJJffoAlhS1skZann6ka55T78ELlkngF5zcYg7Km8ltS1UHkAuKh
# >>   p7KEu1a6c2tjnytpZlAKuPZg7ahVoH7n5zNegSHWPvTqCq0gIngNnAuYGrqYTWBG
# >>   5BFXKEpWwe227A5L+S/vjY2Tkoh0IrnkN9WzmGwJAoGAGg3yIatlDZKuBtINdCQ5
# >>   c6QmuyNMMM4QFUrIf3N0U8Koi3rgqRDXF56beaEyH2gU2UMMnpkVG60/y8HF4X0X
# >>   TGt11B7eKaU2VKPOymki3yr0Lbw0mYvm8ydB8xYZO5NtiqR6vlWyoB1+RpBG0FeM
# >>   Ysb8vIGxssb2ibtHDu9gVTg=
# >>   -----END PRIVATE KEY-----
# >> client_email: shogi-extend@shogi-web-production.iam.gserviceaccount.com
# >> client_id: '108907797530456833009'
# >> auth_uri: https://accounts.google.com/o/oauth2/auth
# >> token_uri: https://oauth2.googleapis.com/token
# >> auth_provider_x509_cert_url: https://www.googleapis.com/oauth2/v1/certs
# >> client_x509_cert_url: https://www.googleapis.com/robot/v1/metadata/x509/shogi-extend%40shogi-web-production.iam.gserviceaccount.com
# >> universe_domain: googleapis.com
# >> |-----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                        type | service_account                                                                                                                                                                                                                                                     |
# >> |                  project_id | shogi-web-development                                                                                                                                                                                                                                               |
# >> |              private_key_id | 2792594c71a6dbc44224c0f666f6fe16ba5d0dab                                                                                                                                                                                                                            |
# >> |                 private_key | -----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCgpJfxqVXZ+xeC\nvyLY/R+OO8j2tmxyXerxkIQh2h6CvqQW3NupzYI/H0Vq0pkUVrdkqMmKZi09XnvE\n4Jbtk/uS2C/C6Wj1jm6BuaoHEynbO0O4Q7WFa/X9USQDKDSYRj2y7lGC5qC2C1Fn\nItk/TiYun3k8kH0SEJ+TESF9A/AAF... |
# >> |                client_email | shogi-extend-development@shogi-web-development.iam.gserviceaccount.com                                                                                                                                                                                              |
# >> |                   client_id | 108798259944174897359                                                                                                                                                                                                                                               |
# >> |                    auth_uri | https://accounts.google.com/o/oauth2/auth                                                                                                                                                                                                                           |
# >> |                   token_uri | https://oauth2.googleapis.com/token                                                                                                                                                                                                                                 |
# >> | auth_provider_x509_cert_url | https://www.googleapis.com/oauth2/v1/certs                                                                                                                                                                                                                          |
# >> |        client_x509_cert_url | https://www.googleapis.com/robot/v1/metadata/x509/shogi-extend-development%40shogi-web-development.iam.gserviceaccount.com                                                                                                                                          |
# >> |             universe_domain | googleapis.com                                                                                                                                                                                                                                                      |
# >> |-----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |-----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                        type | service_account                                                                                                                                                                                                                                                     |
# >> |                  project_id | shogi-web-development                                                                                                                                                                                                                                               |
# >> |              private_key_id | 2792594c71a6dbc44224c0f666f6fe16ba5d0dab                                                                                                                                                                                                                            |
# >> |                 private_key | -----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCgpJfxqVXZ+xeC\nvyLY/R+OO8j2tmxyXerxkIQh2h6CvqQW3NupzYI/H0Vq0pkUVrdkqMmKZi09XnvE\n4Jbtk/uS2C/C6Wj1jm6BuaoHEynbO0O4Q7WFa/X9USQDKDSYRj2y7lGC5qC2C1Fn\nItk/TiYun3k8kH0SEJ+TESF9A/AAF... |
# >> |                client_email | shogi-extend-development@shogi-web-development.iam.gserviceaccount.com                                                                                                                                                                                              |
# >> |                   client_id | 108798259944174897359                                                                                                                                                                                                                                               |
# >> |                    auth_uri | https://accounts.google.com/o/oauth2/auth                                                                                                                                                                                                                           |
# >> |                   token_uri | https://oauth2.googleapis.com/token                                                                                                                                                                                                                                 |
# >> | auth_provider_x509_cert_url | https://www.googleapis.com/oauth2/v1/certs                                                                                                                                                                                                                          |
# >> |        client_x509_cert_url | https://www.googleapis.com/robot/v1/metadata/x509/shogi-extend-development%40shogi-web-development.iam.gserviceaccount.com                                                                                                                                          |
# >> |             universe_domain | googleapis.com                                                                                                                                                                                                                                                      |
# >> |-----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |-----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                        type | service_account                                                                                                                                                                                                                                                     |
# >> |                  project_id | shogi-web-production                                                                                                                                                                                                                                                |
# >> |              private_key_id | 39fc60ffd0a48d9f488fe42e19e5f04235d8568d                                                                                                                                                                                                                            |
# >> |                 private_key | -----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCn9QkBZPyoralY\nLBRXgQgajPTTle6XwKk+WIkoj5zT+vc52arzuU7zmDynP4pEoKYNIPYe9GW+HK+c\nbu3U0Cxkvo9qQtmAuxDGNZtN23h8vN/NYXGxFgAnmHukgVZvyDQ8MNDusK0jpmoF\npIWL6kNBFdTvhlRx6G8dnjZNcBr//... |
# >> |                client_email | shogi-extend@shogi-web-production.iam.gserviceaccount.com                                                                                                                                                                                                           |
# >> |                   client_id | 108907797530456833009                                                                                                                                                                                                                                               |
# >> |                    auth_uri | https://accounts.google.com/o/oauth2/auth                                                                                                                                                                                                                           |
# >> |                   token_uri | https://oauth2.googleapis.com/token                                                                                                                                                                                                                                 |
# >> | auth_provider_x509_cert_url | https://www.googleapis.com/oauth2/v1/certs                                                                                                                                                                                                                          |
# >> |        client_x509_cert_url | https://www.googleapis.com/robot/v1/metadata/x509/shogi-extend%40shogi-web-production.iam.gserviceaccount.com                                                                                                                                                       |
# >> |             universe_domain | googleapis.com                                                                                                                                                                                                                                                      |
# >> |-----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |-----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |                        type | service_account                                                                                                                                                                                                                                                     |
# >> |                  project_id | shogi-web-production                                                                                                                                                                                                                                                |
# >> |              private_key_id | 39fc60ffd0a48d9f488fe42e19e5f04235d8568d                                                                                                                                                                                                                            |
# >> |                 private_key | -----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCn9QkBZPyoralY\nLBRXgQgajPTTle6XwKk+WIkoj5zT+vc52arzuU7zmDynP4pEoKYNIPYe9GW+HK+c\nbu3U0Cxkvo9qQtmAuxDGNZtN23h8vN/NYXGxFgAnmHukgVZvyDQ8MNDusK0jpmoF\npIWL6kNBFdTvhlRx6G8dnjZNcBr//... |
# >> |                client_email | shogi-extend@shogi-web-production.iam.gserviceaccount.com                                                                                                                                                                                                           |
# >> |                   client_id | 108907797530456833009                                                                                                                                                                                                                                               |
# >> |                    auth_uri | https://accounts.google.com/o/oauth2/auth                                                                                                                                                                                                                           |
# >> |                   token_uri | https://oauth2.googleapis.com/token                                                                                                                                                                                                                                 |
# >> | auth_provider_x509_cert_url | https://www.googleapis.com/oauth2/v1/certs                                                                                                                                                                                                                          |
# >> |        client_x509_cert_url | https://www.googleapis.com/robot/v1/metadata/x509/shogi-extend%40shogi-web-production.iam.gserviceaccount.com                                                                                                                                                       |
# >> |             universe_domain | googleapis.com                                                                                                                                                                                                                                                      |
# >> |-----------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
