require "rails_helper"

module Swars
  RSpec.describe User::Vip, type: :model, swars_spec: true do
    it ".auto_crawl_user_keys" do
      assert { User::Vip.auto_crawl_user_keys.include?("abacus10") }
      assert { User::Vip.auto_crawl_user_keys.include?("BOUYATETSU5") }
    end

    it ".long_time_keep_user_keys" do
      assert { User::Vip.long_time_keep_user_keys.include?("abacus10") }
    end

    it ".protected_user_keys" do
      assert { User::Vip.protected_user_keys.include?("BOUYATETSU5") }
      assert { User::Vip.protected_user_keys.include?("SiroChannel") }
    end
  end
end
