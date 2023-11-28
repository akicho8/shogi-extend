require "rails_helper"

RSpec.describe FreeSpace, type: :model do
  it "works" do
    assert { FreeSpace.new.call.match?(/\A\d+%\z/) }
    assert { FreeSpace.new.call{}.size == 2        }
  end
end
