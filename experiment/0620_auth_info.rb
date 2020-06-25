#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

auth_info = AuthInfo.last
tp auth_info
tp auth_info.meta_info.dig("info", "description")
pp auth_info.meta_info
# >> |-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> |        id | 1                                                                                                                                                                                                                                                                   |
# >> |   user_id | 9                                                                                                                                                                                                                                                                   |
# >> |  provider | google                                                                                                                                                                                                                                                              |
# >> |       uid | 101367992961344409174                                                                                                                                                                                                                                               |
# >> | meta_info | {"provider"=>"google", "uid"=>"101367992961344409174", "info"=>{"email"=>"pinpon.ikeda@gmail.com", "unverified_email"=>"pinpon.ikeda@gmail.com", "email_verified"=>true, "image"=>"https://lh3.googleusercontent.com/a-/AOh14GgUBLAKjH8MpDllLTb_MRXoRVfsrE21R34F... |
# >> |-----------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
# >> {"provider"=>"google",
# >>  "uid"=>"101367992961344409174",
# >>  "info"=>
# >>   {"email"=>"pinpon.ikeda@gmail.com",
# >>    "unverified_email"=>"pinpon.ikeda@gmail.com",
# >>    "email_verified"=>true,
# >>    "image"=>
# >>     "https://lh3.googleusercontent.com/a-/AOh14GgUBLAKjH8MpDllLTb_MRXoRVfsrE21R34FOSwBMg"},
# >>  "credentials"=>
# >>   {"token"=>
# >>     "ya29.a0AfH6SMCRpR9rYVVRoNxdeEycFStaY-qm-iiTaZS1P1vSGE2gAXbkInMxNwysTDQvZ5tii-V-JcyhhSmchObKpm7HAdp-0dqdU5Al4t4akvyEIAGtERqTHQViix2SHPfaK886ugIfkTSTRF4cMeIgY3w8xYU3vRzwY_oXMg",
# >>    "expires_at"=>1593058882,
# >>    "expires"=>true},
# >>  "extra"=>
# >>   {"id_token"=>
# >>     "eyJhbGciOiJSUzI1NiIsImtpZCI6ImUyMDI4MmY0NDE1NjdjNWVjYjYwNjQ4ODc2ODU3ZjdiOGM1MWM0M2EiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI3NDQwMjIxMzgzNC1naXI0aGFjdGwzcTVrbGZqM2R1cjA5cjlrM3BiaWt2Mi5hcHBzLmdvb2dsZXVzZXJjb250ZW50LmNvbSIsImF1ZCI6Ijc0NDAyMjEzODM0LWdpcjRoYWN0bDNxNWtsZmozZHVyMDlyOWszcGJpa3YyLmFwcHMuZ29vZ2xldXNlcmNvbnRlbnQuY29tIiwic3ViIjoiMTAxMzY3OTkyOTYxMzQ0NDA5MTc0IiwiZW1haWwiOiJwaW5wb24uaWtlZGFAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJMWkswOVBuRk1reGlJNTBWenVpQ1l3IiwiaWF0IjoxNTkzMDU1MjgyLCJleHAiOjE1OTMwNTg4ODJ9.XcepcN3_xKfLm4i71JyruNO2BqBtPS6R-rOake88vtIc1At4Sa__RmDbq6lNZN6RLPfwULYia82zF9B1zwFhun1yMmbyZa-fJh-f7oSDmmBX9sYTT8aBMMFQUWUYNeh12By3AsqDPvaeP0RsEnO4tp5BVjTHOMcmbTkIHtPgrkPdzkW6Cg7msG6RjXg0tQmxDDJYEBaHNjXXIHZ5RHYl-x50lGFJrlSU4r1u0VBHZ1B9jSkcujhUPxKF671gIGUTinzt3sk4_eNDA7_nnYuSITpauU4Te0cBRccMJSGG1Lr4yWk_mtyZ7sEuqurZ-TbOOAXOUILqpZY9DdSluak1yA",
# >>    "id_info"=>
# >>     {"iss"=>"https://accounts.google.com",
# >>      "azp"=>
# >>       "74402213834-gir4hactl3q5klfj3dur09r9k3pbikv2.apps.googleusercontent.com",
# >>      "aud"=>
# >>       "74402213834-gir4hactl3q5klfj3dur09r9k3pbikv2.apps.googleusercontent.com",
# >>      "sub"=>"101367992961344409174",
# >>      "email"=>"pinpon.ikeda@gmail.com",
# >>      "email_verified"=>true,
# >>      "at_hash"=>"LZK09PnFMkxiI50VzuiCYw",
# >>      "iat"=>1593055282,
# >>      "exp"=>1593058882},
# >>    "raw_info"=>
# >>     {"sub"=>"101367992961344409174",
# >>      "picture"=>
# >>       "https://lh3.googleusercontent.com/a-/AOh14GgUBLAKjH8MpDllLTb_MRXoRVfsrE21R34FOSwBMg",
# >>      "email"=>"pinpon.ikeda@gmail.com",
# >>      "email_verified"=>true}}}
