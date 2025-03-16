require "rails_helper"

RSpec.describe QuickScript::Swars::PrisonNewScript, type: :model do
  xit "works" do
    response = QuickScript::Swars::PrisonNewScript.new(_method: "post", swars_user_key: "foo").as_json
    # redis が参照できないので動かない
  end
end
