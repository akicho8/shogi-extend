require "rails_helper"

RSpec.describe Swars::User::Vip, type: :model, swars_spec: true do
  it ".auto_crawl_user_keys" do
    assert { Swars::User::Vip.auto_crawl_user_keys.include?("abacus10") }
    assert { Swars::User::Vip.auto_crawl_user_keys.include?("BOUYATETSU5") }
  end

  it ".long_time_keep_user_keys" do
    assert { Swars::User::Vip.long_time_keep_user_keys.include?("abacus10") }
  end

  it ".protected_user_keys" do
    assert { Swars::User::Vip.protected_user_keys == [] }
  end
end
