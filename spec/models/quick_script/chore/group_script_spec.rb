require "rails_helper"

RSpec.describe QuickScript::Chore::GroupScript, type: :model do
  it "admin_only 指定のグループは基本見えないが admin_user 権限があれば見える" do
    object = QuickScript::Chore::GroupScript.new
    assert { object.all.include?(QuickScript::QsGroupInfo.fetch(:dev)) == false }

    object = QuickScript::Chore::GroupScript.new({}, admin_user: Object.new)
    assert { object.all.include?(QuickScript::QsGroupInfo.fetch(:dev)) == true }
  end
end
