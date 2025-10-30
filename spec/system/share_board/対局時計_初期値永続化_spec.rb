require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    @CLOCK_VALUES = [1, 2, 3, 4]

    visit_app

    clock_open
    clock_box_form_set(:black, *@CLOCK_VALUES) # aが時計を設定する
    find(".play_button").click         # 開始 (このタイミングで初期値として保存する)

    visit(current_path)                # リロード
    clock_open
    clock_box_form_eq(:black, *@CLOCK_VALUES) # 時計の初期値が復帰している
  end
end
