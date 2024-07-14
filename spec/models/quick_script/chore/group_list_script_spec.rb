require "rails_helper"

module QuickScript
  RSpec.describe Chore::GroupListScript, type: :model do
    it "admin_only 指定のグループは基本見えないが admin_user 権限があれば見える" do
      object = Chore::GroupListScript.new
      assert { object.all.include?(QsGroupInfo.fetch(:dev)) == false }

      object = Chore::GroupListScript.new({}, admin_user: Object.new)
      assert { object.all.include?(QsGroupInfo.fetch(:dev)) == true }
    end
  end
end
