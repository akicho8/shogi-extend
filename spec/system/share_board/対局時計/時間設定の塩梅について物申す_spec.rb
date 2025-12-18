require "#{__dir__}/../sb_support_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(params)
    visit_app({ **clock_box_params(params), autoexec: "cc_create,cc_modal_open_handle" })
  end

  it "works" do
    case1([0, 30, 5, 0])
    assert_selector(".validate_message", text: "GOOD", exact_text: true)
  end
end
