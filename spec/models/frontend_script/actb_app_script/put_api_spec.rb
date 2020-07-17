# -*- coding: utf-8 -*-
# == Schema Information ==
#
# ユーザー (users as User)
#
# |------------------------+----------------------------+-------------+---------------------+------+-------|
# | name                   | desc                       | type        | opts                | refs | index |
# |------------------------+----------------------------+-------------+---------------------+------+-------|
# | id                     | ID                         | integer(8)  | NOT NULL PK         |      |       |
# | key                    | ユニークなハッシュ         | string(255) | NOT NULL            |      | A!    |
# | name                   | 名前                       | string(255) | NOT NULL            |      |       |
# | cpu_brain_key          | CPUの思考タイプ            | string(255) |                     |      |       |
# | user_agent             | User agent                 | string(255) | NOT NULL            |      |       |
# | race_key               | 種族                       | string(255) | NOT NULL            |      | F     |
# | created_at             | 作成日                     | datetime    | NOT NULL            |      |       |
# | updated_at             | 更新日                     | datetime    | NOT NULL            |      |       |
# | email                  | メールアドレス             | string(255) | NOT NULL            |      | B!    |
# | encrypted_password     | 暗号化パスワード           | string(255) | NOT NULL            |      |       |
# | reset_password_token   | Reset password token       | string(255) |                     |      | C!    |
# | reset_password_sent_at | パスワードリセット送信時刻 | datetime    |                     |      |       |
# | remember_created_at    | ログイン記憶時刻           | datetime    |                     |      |       |
# | sign_in_count          | ログイン回数               | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | current_sign_in_at     | 現在のログイン時刻         | datetime    |                     |      |       |
# | last_sign_in_at        | 最終ログイン時刻           | datetime    |                     |      |       |
# | current_sign_in_ip     | 現在のログインIPアドレス   | string(255) |                     |      |       |
# | last_sign_in_ip        | 最終ログインIPアドレス     | string(255) |                     |      |       |
# | confirmation_token     | パスワード確認用トークン   | string(255) |                     |      | D!    |
# | confirmed_at           | パスワード確認時刻         | datetime    |                     |      |       |
# | confirmation_sent_at   | パスワード確認送信時刻     | datetime    |                     |      |       |
# | unconfirmed_email      | 未確認Eメール              | string(255) |                     |      |       |
# | failed_attempts        | 失敗したログイン試行回数   | integer(4)  | DEFAULT(0) NOT NULL |      |       |
# | unlock_token           | Unlock token               | string(255) |                     |      | E!    |
# | locked_at              | ロック時刻                 | datetime    |                     |      |       |
# |------------------------+----------------------------+-------------+---------------------+------+-------|

require 'rails_helper'

RSpec.describe FrontendScript::ActbAppScript::PutApi, type: :model do
  include ActbSupportMethods

  it do
    # object = FrontendScript::ActbAppScript.new({})
    # object.profile_update       # => 
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> F
# >> 
# >> Failures:
# >> 
# >>   1) FrontendScript::ActbAppScript::PutApi 
# >>      Failure/Error: delegate :current_user, to: :h
# >> 
# >>      Module::DelegationError:
# >>        FrontendScript::ActbAppScript#current_user delegated to h.current_user, but h is nil: #<FrontendScript::ActbAppScript:0x00007fc638b9ce58 @params={}, @view_context=nil, @controller=nil>
# >>      # ./app/models/frontend_script/actb_app_script.rb:51:in `rescue in current_user'
# >>      # ./app/models/frontend_script/actb_app_script.rb:51:in `current_user'
# >>      # ./app/models/frontend_script/actb_app_script/put_api.rb:105:in `profile_update'
# >>      # -:43:in `block (2 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:18:in `block (3 levels) in <main>'
# >>      # ./spec/support/database_cleaner.rb:18:in `block (2 levels) in <main>'
# >>      # ------------------
# >>      # --- Caused by: ---
# >>      # NoMethodError:
# >>      #   undefined method `current_user' for nil:NilClass
# >>      #   ./app/models/frontend_script/actb_app_script.rb:51:in `current_user'
# >> 
# >> Finished in 0.21094 seconds (files took 2.23 seconds to load)
# >> 1 example, 1 failure
# >> 
# >> Failed examples:
# >> 
# >> rspec -:41 # FrontendScript::ActbAppScript::PutApi 
# >> 
