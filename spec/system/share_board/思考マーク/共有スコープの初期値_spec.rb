require "#{__dir__}/helper"

RSpec.describe "共有スコープの初期値", type: :system, share_board_spec: true do
  it "works" do
    visit_app(think_mark_receive_scope_key: :tmrs_everyone) # ここでの設定は
    visit_app                                               # ここで引き継がれない
    assert_system_variable :think_mark_receive_scope_key, :tmrs_watcher_only
  end
end
