require "rails_helper"

RSpec.describe SlackAgent do
  it "works" do
    ret_hash = SlackAgent.notify(subject: "(key)", body: "(body)", emoji: ":SOS:")
    assert { ret_hash[:text] == "🆘 0 w0 00:00:00.000【(key)】(body)" }
  end
end
