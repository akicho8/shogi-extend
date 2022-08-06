require "rails_helper"

module Swars
  RSpec.describe KentoApi, type: :model, swars_spec: true do
    it "as_json だけ反応すれば良い" do
      user = User.create!
      Battle.create_with_members!([user])
      kento_api = KentoApi.new(user: user)
      json = kento_api.as_json
      assert { json["game_list"].present? }
    end
  end
end
