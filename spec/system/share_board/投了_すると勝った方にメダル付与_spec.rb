require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(user_name)
    visit_app({
        :room_code                  => :my_room,
        :fixed_user_name            => user_name,
        :fixed_member_names         => "alice,bob",
        :fixed_order_names          => "alice,bob",
        :clock_box_initial_main_min => 60,
        :clock_box_play_handle      => true,
      })
    Capybara.using_wait_time(0) { debugger }
  end

  it "works" do
    a_block { case1("alice") }
    b_block { case1("bob")   }
    b_block do
      find("a", text: "投了", exact_text: true).click # bob は手番ではないがヘッダーの「投了」ボタンを押す
      find(:button, "本当に投了する").click           # モーダルが表示されるので本当に投了する
    end
    a_block do
      # Capybara.using_wait_time(0) { debugger }
    end
  end
end
