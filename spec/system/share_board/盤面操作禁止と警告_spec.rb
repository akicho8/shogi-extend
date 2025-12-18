require "#{__dir__}/sb_support_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "順番設定をしたのに時計で対局開始せずに盤に触った (あるある)" do
    visit_room({
        :user_name => "a",
        :FIXED_MEMBER => "a,b",
        :FIXED_ORDER => "a,b,c",
      })
    place_click("11")
    assert_text "対局するなら対局時計を押そう"
    assert_text "検討するなら駒を動かせるように順番設定を解除しよう"
  end

  # 本番では「順番設定」→「時計」の順で設定してもらうのでこうなることはないのだが、よそ見の影響でこの不整合状態になる場合がある
  # 具体的には順番設定したホストAがよそ見して、順番設定をしていないBの方がホストになってしまった場合に、
  # B から情報を貰った A は、順番設定が OFF に戻ってしまう。
  it "時計は動いているのに順番設定がOFFの状態で盤に触った" do
    visit_room({
        :user_name => "a",
        :FIXED_MEMBER => "a,b",
        :room_after_create => :cc_auto_start_10m,
      })
    place_click("11")
    assert_text "対局する場合は順番設定しよう"
  end

  it "自分は観戦者なのに盤に触った" do
    visit_room({
        :user_name => "c",
        :FIXED_MEMBER => "a,b,c",
        :FIXED_ORDER => "a,b",
        :room_after_create => :cc_auto_start_10m,
      })
    place_click("11")
    assert_text "cさんは観戦者なので触らんといてください"
    assert_text "暇だったら盤を右クリックして検討しよう"
  end

  it "自分は対局者だが手番ではないのに盤に触った (あるある)" do
    visit_room({
        :user_name => "b",
        :FIXED_MEMBER => "a,b",
        :FIXED_ORDER => "a,b",
        :room_after_create => :cc_auto_start_10m,
      })
    place_click("11")
    assert_text "今はaさんの手番です"
    assert_text "bさんは次です"
  end

  # 本番の順番設定のUIではそれぞれのチームに最低1人入れないといけないのでこの警告がでることはない
  it "「今は○○さんの手番です」と警告を出したいのだが順番設定の現在手番に該当する人が設定されていない" do
    visit_room({
        :user_name => "a",
        :FIXED_MEMBER => "a",
        :FIXED_ORDER => "a",
        :FIXED_ORDER_SWAP => true, # これによって a は後手番になる。body: SfenGenerator.start_from(:white) で FIXED_ORDER_SWAP を使わない方法でもよい。
        :room_after_create => :cc_auto_start_10m,
      })
    place_click("11")
    assert_text "順番設定で対局者の指定がないので誰も操作できません"
  end
end
