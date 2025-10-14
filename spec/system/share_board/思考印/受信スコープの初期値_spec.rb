require "#{__dir__}/helper"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app(think_mark_receive_scope_key: :tmrs_everyone) # ここでの設定は
    visit_app                                               # ここで引き継がれない
    assert_var :think_mark_receive_scope_key, :tmrs_watcher_only
  end
end
