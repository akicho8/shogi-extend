require 'rails_helper'

module Swars
  RSpec.describe Grade, type: :model do
    before do
      Swars.setup
    end

    it "name" do
      assert { Grade.find_by!(key: "十段").name == "十段" }
    end
  end
end
