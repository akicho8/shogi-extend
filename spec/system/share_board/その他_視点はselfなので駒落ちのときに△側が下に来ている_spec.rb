require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_app({
        :abstract_viewpoint => "self",
        :body               => SfenGenerator.start_from(:white),
      })
    assert_viewpoint(:white)
  end
end
