require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  before do
    @initial_read_sec         = 5 # 5秒切れ負け
    @CC_TIME_LIMIT_BC_DELAY   = 0 # 当事者はN秒待って他者たちに時間切れをBCする (ネット遅延のシミュレート)
    @CC_AUTO_TIME_LIMIT_DELAY = 3 # 通知が来なくてもN秒後に自力で時間切れモーダルを表示
  end

  def case1(fixed_user_name)
    visit_app({
        "room_code"                => "test_room",
        "fixed_user_name"          => fixed_user_name,
        "fixed_member_names"       => "alice,bob",
        "fixed_order_names"        => "alice,bob",
        "RETRY_DELAY"              => -1,
        "CC_AUTO_TIME_LIMIT_DELAY" => @CC_AUTO_TIME_LIMIT_DELAY,
        "CC_TIME_LIMIT_BC_DELAY"   => @CC_TIME_LIMIT_BC_DELAY,
        **clock_box_params([0, @initial_read_sec, 0, 0]),
      })
  end

  it "当事者側(自分は即座に起動してBC)" do
    a_block { case1("alice") }
    b_block { case1("bob")   }
    a_block { clock_start    }
    a_block do
      sleep(@initial_read_sec)
      Capybara.using_wait_time(@CC_TIME_LIMIT_BC_DELAY * 2) do
        assert_text("当事者は自分で起動してBC")
        assert_timeout_modal_exist
        assert_text("BC受信時にはすでにモーダル起動済み")
      end
    end
    b_block { assert_timeout_modal_exist }
  end

  it "他者側(予約するがBCの方が速いのでキャンセルされる)" do
    @CC_TIME_LIMIT_BC_DELAY   = 2
    @CC_AUTO_TIME_LIMIT_DELAY = 4
    a_block { case1("alice") }
    b_block { case1("bob")   }
    a_block { clock_start    }
    b_block do
      sleep(@initial_read_sec)
      Capybara.using_wait_time(@CC_TIME_LIMIT_BC_DELAY * 2) do
        assert_text("BC受信によってモーダル起動開始")
        assert_text("時間切れ予約キャンセル")
        assert_timeout_modal_exist
      end
    end
    a_block { assert_timeout_modal_exist }
  end

  it "他者側(予約待ち0なので他者側で即発動)" do
    @CC_TIME_LIMIT_BC_DELAY   = 5
    @CC_AUTO_TIME_LIMIT_DELAY = 0
    a_block { case1("alice") }
    b_block { case1("bob")   }
    a_block { clock_start    }
    b_block do
      sleep(@initial_read_sec)
      Capybara.using_wait_time(@CC_TIME_LIMIT_BC_DELAY * 2) do
        assert_text("BC受信時にはすでにモーダル起動済み")
        assert_timeout_modal_exist
      end
    end
    a_block { assert_timeout_modal_exist }
  end
end
