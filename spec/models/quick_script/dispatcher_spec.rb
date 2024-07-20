require "rails_helper"

module QuickScript
  RSpec.describe Dispatcher, type: :model do
    it "dispatch" do
      assert { Dispatcher.dispatch(qs_group_key: "dev", qs_page_key: "null") }
    end

    it "background_dispatch" do
      assert { Dispatcher.background_dispatch({qs_group_key: "dev", qs_page_key: "null"}, {current_user_id: User.create!}) == nil }
    end
  end
end
