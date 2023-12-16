require "rails_helper"

module ShareBoard
  RSpec.describe Broadcaster do
    it "works" do
      Broadcaster.new.call("message_share_broadcasted", content: "OK")
    end
  end
end
