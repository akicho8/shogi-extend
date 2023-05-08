require "rails_helper"

RSpec.describe FreeSpace, type: :model do
  it "works" do
    assert2 { FreeSpace.new.call.match?(/\A\d+%\z/) }
    assert2 { FreeSpace.new.call{}.size == 2        }
  end
end
