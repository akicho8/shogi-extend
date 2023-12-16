require "rails_helper"

RSpec.describe ShareBoard::MessageScopeInfo do
  it "works" do
    assert { ShareBoard::MessageScopeInfo[:ms_public] }
  end
end
