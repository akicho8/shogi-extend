require "rails_helper"

module Swars
  RSpec.describe SystemValidator, type: :model, swars_spec: true do
    it "works" do
      SystemValidator.new.call
    end
  end
end
