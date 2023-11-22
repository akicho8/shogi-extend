require "rails_helper"

RSpec.describe UrlHandling do
  it "works" do
    url_handling = UrlHandling.create!(original_url: "http://localhost:3000/")
    url_handling = UrlHandling.find_by!(key: url_handling.key)
    assert2 { url_handling.short_url == "http://localhost:3000/url/#{url_handling.key}" }
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> UrlHandling
# >> 2023-11-22T12:22:04.816Z pid=26860 tid=myg INFO: Sidekiq 7.1.6 connecting to Redis with options {:size=>10, :pool_name=>"internal", :url=>"redis://localhost:6379/4"}
# >>   works
# >> 
# >> Top 1 slowest examples (0.14201 seconds, 9.9% of total time):
# >>   UrlHandling works
# >>     0.14201 seconds -:4
# >> 
# >> Finished in 1.43 seconds (files took 2.49 seconds to load)
# >> 1 example, 0 failures
# >> 
