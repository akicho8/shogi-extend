require "rails_helper"

RSpec.describe UrlProxy do
  it "to_share_board_url" do
    is_asserted_by { UrlProxy.full_url_for({path: "/", query: { body: "a b+" }}) == "http://localhost:4000/?body=a+b%2B" }
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> UrlProxy
# >>   to_share_board_url
# >> 
# >> Top 1 slowest examples (0.07766 seconds, 5.7% of total time):
# >>   UrlProxy to_share_board_url
# >>     0.07766 seconds -:4
# >> 
# >> Finished in 1.36 seconds (files took 3.57 seconds to load)
# >> 1 example, 0 failures
# >> 
