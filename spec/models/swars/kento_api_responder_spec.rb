require "rails_helper"

RSpec.describe Swars::KentoApiResponder, type: :model, swars_spec: true do
  it "as_json" do
    user = Swars::User.create!
    Swars::Battle.create_with_members!([user])
    kento_api_responder = Swars::KentoApiResponder.new(user: user)
    json = kento_api_responder.as_json
    assert { json["game_list"].present? }
  end

  it "特定IDは除外する" do
    user = Swars::User.create!(key: "marudedna")
    kento_api_responder = Swars::KentoApiResponder.new(user: user)
    assert { kento_api_responder.black_user? }
  end
end
