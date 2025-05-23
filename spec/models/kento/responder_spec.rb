require "rails_helper"

RSpec.describe Kento::Responder, type: :model, swars_spec: true do
  it "as_json" do
    user = Swars::User.create!
    Swars::Battle.create_with_members!([user])
    responder = Kento::Responder.new(user: user)
    json = responder.as_json
    assert { json[:game_list].present? }
  end
end
