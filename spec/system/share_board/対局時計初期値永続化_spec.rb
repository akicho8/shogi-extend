require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    @CLOCK_VALUES = [1, 2, 3, 4]

    visit "/share-board"

    clock_open
    clock_box_set(*@CLOCK_VALUES)      # aliceが時計を設定する
    find(".play_button").click         # 開始 (このタイミングで初期値として保存する)

    visit(current_path)                # リロード
    clock_open
    clock_box_values_eq(@CLOCK_VALUES) # 時計の初期値が復帰している
  end
end
