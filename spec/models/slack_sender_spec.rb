require "rails_helper"

RSpec.describe SlackSender do
  it "works" do
    api_params = SlackSender.call(subject: "(subject)", body: "(body)", emoji: ":SOS:")
    assert { api_params[:channel] == "#shogi-extend-test" }
    assert { api_params[:text] == "🆘 0 00:00:00.000【(subject)】(body)" }
  end
end
