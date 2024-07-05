require "rails_helper"

module Swars
  RSpec.describe UserKey, type: :model, swars_spec: true do
    it "works" do
      assert { UserKey["xxx"].my_page_url }
    end
  end
end
