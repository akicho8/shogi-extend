require "rails_helper"

module QuickScript
  RSpec.describe Chore::GroupScript, type: :model do
    it "admin_only 指定のグループは基本見えないが admin_user 権限があれば見える" do
      object = Chore::GroupScript.new
      assert { object.all.include?(QsGroupInfo.fetch(:dev)) == false }

      object = Chore::GroupScript.new({}, admin_user: Object.new)
      assert { object.all.include?(QsGroupInfo.fetch(:dev)) == true }
    end
  end
end
