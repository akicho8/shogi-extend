require "rails_helper"

RSpec.describe "システムテスト自体が動く", type: :system do
  # cd ~/src/shogi-extend/ && BROWSER_DEBUG=1 rspec ~/src/shogi-extend/spec/system/nuxt_side_spec.rb
  it "works" do
    visit "/"
    assert_selector(".NavbarItemLogin")
  end
end
