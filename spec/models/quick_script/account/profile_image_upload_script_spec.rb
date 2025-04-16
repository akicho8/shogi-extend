require "rails_helper"

RSpec.describe QuickScript::Account::ProfileImageUploadScript, type: :model do
  it "works" do
    user = User.create!
    params = { avatar: { data_uri: MiniImage.generate } }
    json = QuickScript::Account::ProfileImageUploadScript.new(params, { current_user: user, _method: :post }).as_json
    assert { json[:redirect_to] }
  end
end
