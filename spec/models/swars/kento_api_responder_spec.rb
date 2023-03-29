require "rails_helper"

module Swars
  RSpec.describe KentoApiResponder, type: :model, swars_spec: true do
    it "as_json" do
      user = User.create!
      Battle.create_with_members!([user])
      kento_api_responder = KentoApiResponder.new(user: user)
      json = kento_api_responder.as_json
      assert2 { json["game_list"].present? }
    end

    it "特定IDは除外する" do
      user = User.create!(key: "marudedna")
      kento_api_responder = KentoApiResponder.new(user: user)
      assert2 { kento_api_responder.black_user? }
    end
  end
end
