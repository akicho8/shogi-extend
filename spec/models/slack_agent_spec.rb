require "rails_helper"

RSpec.describe SlackAgent do
  it "works" do
    api_params = SlackAgent.notify(subject: "(key)", body: "(body)", emoji: ":SOS:")
    is_asserted_by { api_params[:channel] == "#shogi-extend-test" }
    is_asserted_by { api_params[:text] == "🆘 0 w0 00:00:00.000【(key)】(body)" }
  end
end
