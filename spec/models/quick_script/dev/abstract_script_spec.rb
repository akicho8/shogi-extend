require "rails_helper"

module QuickScript
  RSpec.describe Dev::AbstractScript, type: :model do
    it "works" do
      assert { Dispatcher.all.include?(Dev::NullScript) }
      assert { Dispatcher.all.exclude?(Dev::AbstractScript) }
    end
  end
end
