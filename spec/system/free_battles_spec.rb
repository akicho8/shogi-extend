require "rails_helper"

RSpec.describe "棋譜投稿", type: :system do
  # let :record do
  #   FreeBattle.create!(kifu_body: "48玉", title: "(test_title)")
  # end
  #
  # describe "一覧" do
  #   xit "表示" do
  #     visit_to "/x"
  #     assert_text "一覧"
  #   end
  #
  #   xit "modal_id の指定があるときモーダルが出て閉じたとき一覧にも1件表示されている" do
  #     visit_to "/x?modal_id=#{record.to_param}"
  #     find(".delete").click
  #     page.refresh
  #     assert_text "1-1"
  #   end
  # end
  #
  # describe "投稿" do
  #   xit "入力" do
  #     visit_to "/x/new"
  #
  #     text_input_click
  #
  #     expect(page).to have_field "free_battle[kifu_body]"
  #     # expect(page).to have_field "free_battle[kifu_url]"
  #     # expect(page).to have_field "free_battle[kifu_file]"
  #
  #     fill_in "free_battle[kifu_body]", with: "68銀"
  #     fill_in "free_battle[title]", with: "(題名)"
  #     sleep(3)
  #     click_button "保存"
  #
  #     assert_text "(題名)"
  #
  #     # assert_text "嬉野流"
  #     # assert_text "６八銀"
  #
  #   end
  # end
  #
  # describe "詳細(非公開)" do
  #   # it "コピペ新規" do
  #   #   visit_to "/x/#{record.to_param}"
  #   #   click_on "コピペ新規"
  #   #   text_input_click
  #   #   assert_text "48玉"
  #   # end
  #
  #   xit "詳細" do
  #     visit_to "/x/#{record.to_param}"
  #     assert_text "(test_title)"
  #   end
  # end
  #
  # # describe "編集" do
  # #   it "編集" do
  # #     visit_to "/x/#{record.to_param}/edit"
  # #   end
  # # end
  #
  # # click_on("棋譜入力") 相当
  # def text_input_click
  #   find(".input_method_tabs .tabs li:nth-child(1)").click
  # end
end
