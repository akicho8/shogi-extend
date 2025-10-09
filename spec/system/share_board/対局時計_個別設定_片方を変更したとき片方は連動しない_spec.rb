require "#{__dir__}/shared_methods"

RSpec.describe "対局時計_個別設定_片方を変更したとき片方は連動しない", type: :system, share_board_spec: true do
  it "works" do
    window_a do
      room_setup2(:alice)
      clock_open
      clock_box_form_set(:black, 1, 2, 3, 4)        # aliceが時計を設定する
      find(".cbm_cc_unique_mode_sete_handle").click # 個別設定を押す
      clock_box_form_eq(:white, 1, 2, 3, 4)         # ▲側が△にコピーされている
      clock_box_form_set(:white, 5, 6, 7, 8)        # △側を更新する
      clock_box_form_eq(:black, 1, 2, 3, 4)         # ▲側は変更されていない (内容は同じだが別のメモリを指している)
    end
    window_b do
      room_setup2(:bob)
      assert_text "cc_params:[[1,2,3,4],[5,6,7,8]]" # 個別設定がbobにも伝わっている
    end
  end
end
