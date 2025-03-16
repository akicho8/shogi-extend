require "rails_helper"

RSpec.describe ShareBoard::Broadcaster do
  it "works" do
    ShareBoard::Broadcaster.new.call("message_share_broadcasted", content: "OK")
  end
end
