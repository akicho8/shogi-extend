require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "バトル設定をしたのに時計で対局開始せずに盤に触った (あるある)" do
    visit_room({
        :user_name => "a",
        :FIXED_MEMBER => "a,b",
        :FIXED_ORDER => "a,b,c",
      })
    board_place("11").click
    assert_text "対局するなら時計を押そう"
    assert_text "検討するならバトル設定を切ろう"
  end

  # 本番では「バトル設定」→「時計」の順で設定してもらうのでこうなることはないのだが、よそ見の影響でこの不整合状態になる場合がある
  # 具体的にはバトル設定したホストAがよそ見して、バトル設定をしていないBの方がホストになってしまった場合に、
  # B から情報を貰った A は、バトル設定が OFF に戻ってしまう。
  it "時計は動いているのにバトル設定がOFFの状態で盤に触った" do
    visit_room({
        :user_name => "a",
        :FIXED_MEMBER => "a,b",
        :room_after_create => :cc_auto_start_10m,
      })
    board_place("11").click
    assert_text "対局する場合はバトル設定しよう"
  end

  it "自分は観戦者なのに盤に触った" do
    visit_room({
        :user_name => "c",
        :FIXED_MEMBER => "a,b,c",
        :FIXED_ORDER => "a,b",
        :room_after_create => :cc_auto_start_10m,
      })
    board_place("11").click
    assert_text "cさんは観戦者なので触らんといてください"
    assert_text "暇だったら盤を右クリックして観戦者同士で「次の一手」を予想し合おう"
  end

  it "自分は対局者だが手番ではないのに盤に触った (あるある)" do
    visit_room({
        :user_name => "b",
        :FIXED_MEMBER => "a,b",
        :FIXED_ORDER => "a,b",
        :room_after_create => :cc_auto_start_10m,
      })
    board_place("11").click
    assert_text "今はaさんの手番です"
    assert_text "bさんは次です"
  end

  # 本番のバトル設定のUIではそれぞれのチームに最低1人入れないといけないのでこの警告がでることはない
  it "「今は○○さんの手番です」と警告を出したいのだがバトル設定の現在手番に該当する人が設定されていない" do
    visit_room({
        :user_name => "a",
        :FIXED_MEMBER => "a",
        :FIXED_ORDER => "a",
        :FIXED_ORDER_SWAP => true, # これによって a は後手番になる。body: SfenGenerator.start_from(:white) で FIXED_ORDER_SWAP を使わない方法でもよい。
        :room_after_create => :cc_auto_start_10m,
      })
    board_place("11").click
    assert_text "バトル設定で対局者の指定がないので誰も操作できません"
  end
end
