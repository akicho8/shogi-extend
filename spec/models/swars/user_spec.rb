require 'rails_helper'

module Swars
  RSpec.describe User, type: :model do
    it "ユーザー名は大小文字を区別する" do
      User.create!(key: "ALICE")
      assert { User.new(key: "alice").valid? }
    end
  end
end
