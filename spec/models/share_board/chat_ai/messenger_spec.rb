require "rails_helper"

RSpec.describe ShareBoard::ChatAi::Messenger do
  it "works" do
    ShareBoard::ChatAi::Messenger.new.call("TEST OK")
  end
end
