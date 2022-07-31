require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit "/share-board?abstract_viewpoint=self&body=position+sfen+4k4%2F9%2F9%2F9%2F9%2F9%2FPPPPPPPPP%2F1B5R1%2FLNSGKGSNL+w+-+1&turn=0"
    assert_viewpoint(:white)
  end
end
