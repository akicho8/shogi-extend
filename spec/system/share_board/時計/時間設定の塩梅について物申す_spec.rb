require "#{__dir__}/../shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(params)
    visit_app({ **clock_box_params(params), autoexec: "cc_create,cc_modal_open_handle", cable_required_p: false })
  end

  it "works" do
    case1([0, 30, 5, 0])
    assert_selector(".validate_message", text: "最高の設定です", exact_text: true)
  end
end
