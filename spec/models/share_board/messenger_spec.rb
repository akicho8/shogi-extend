require "rails_helper"

RSpec.describe ShareBoard::Messenger do
  it "works" do
    ShareBoard::Messenger.new.call("TEST OK")
  end
end
