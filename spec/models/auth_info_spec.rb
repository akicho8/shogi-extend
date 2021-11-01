# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Auth info (auth_infos as AuthInfo)
#
# |-----------+--------------+-------------+-------------+------------+-------|
# | name      | desc         | type        | opts        | refs       | index |
# |-----------+--------------+-------------+-------------+------------+-------|
# | id        | ID           | integer(8)  | NOT NULL PK |            |       |
# | user_id   | User         | integer(8)  | NOT NULL    | => User#id | B     |
# | provider  | Provider     | string(255) | NOT NULL    |            | A!    |
# | uid       | Uid          | string(255) | NOT NULL    |            | A!    |
# | meta_info | 棋譜ヘッダー | text(65535) |             |            |       |
# |-----------+--------------+-------------+-------------+------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe AuthInfo, type: :model do
  include ActiveJob::TestHelper

  before(:context) do
    Actb.setup
    Emox.setup
  end

  let(:auth) do
    { "info" => { "email" => "sns@example.com" } }
  end

  it "SNS経由で登録すると通知" do
    user = User.create!
    perform_enqueued_jobs do
      user.auth_infos.create!(provider: "twitter", uid: SecureRandom.hex, auth: auth)
    end
    assert { ActionMailer::Base.deliveries.count == 1 }
    # assert { user.email == "sns@example.com" }
    # assert { user.unconfirmed_email.blank? }
    # tp ActionMailer::Base.deliveries.collect { |e| {subject: e.subject, from: e.from, to: e.to} }
  end

  it "正しいメールアドレスのときはSNS連携しても更新しない" do
    user = User.create!(email: "alice@example.com")
    user.auth_infos.create!(provider: "twitter", uid: SecureRandom.hex, auth: auth)
    assert { user.email == "alice@example.com" }
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ..
# >> 
# >> Finished in 1.55 seconds (files took 2.33 seconds to load)
# >> 2 examples, 0 failures
# >> 
