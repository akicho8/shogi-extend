require "rails_helper"

RSpec.describe SlackSender do
  it "works" do
    api_params = SlackSender.call(subject: "(key)", body: "(body)", emoji: ":SOS:")
    assert2 { api_params[:channel] == "#shogi-extend-test" }
    assert2 { api_params[:text] == "🆘 0 00:00:00.000【(key)】(body)" }
  end
end
