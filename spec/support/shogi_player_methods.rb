module ShogiPlayerMethods
  # 将棋盤内でプレイヤー名が表示されている
  def assert_has_sp_player_name
    assert_no_selector(".MembershipLocationPlayerInfoName")
  end

  # 将棋盤内で location_key 側のプレイヤー名は user_name になっている
  def assert_sp_player_name(location_key, user_name)
    within(".ShogiPlayer") do
      assert_selector(:element, :class => ["Membership", "is_#{location_key}"], text: user_name, exact_text: true)
    end
  end

  # ▲△の順に指定のプレイヤー名を表示している
  def assert_sp_player_names(black_name, white_name)
    assert_sp_player_name(:black, black_name)
    assert_sp_player_name(:white, white_name)
  end

  def sp_controller_click(klass)
    find(".ShogiPlayer .NavigateBlock .button.#{klass}").click
  end

  # 向き
  def assert_viewpoint(location_key)
    assert_selector(".CustomShogiPlayer.is_viewpoint_#{location_key}")
  end

  # from から to に移動する
  def piece_move(from, to)
    [from, to].each { |e| place_click(e) }
  end

  # place_click("76") は find(".place_7_6").click 相当
  def place_click(place)
    find(place_class(place)).click
  end

  def place_class(place)
    [".place", place.chars].join("_")
  end

  # place の位置の駒を持ち上げ中か？
  def lifted_from(place)
    assert_selector "#{place_class(place)}.lifted_from_p"
  end

  # place の位置の駒を持ち上げてない
  def no_lifted_from(place)
    assert_no_selector "#{place_class(place)}.lifted_from_p"
  end

  # location_key 色の piece_key が盤上にある
  def assert_soldier_exist(location_key, piece_key, promoted)
    assert_selector ".ShogiPlayer .MainBoard .PieceTexture.location_#{location_key}.promoted_#{promoted}.piece_name.piece_#{piece_key}"
  end
end
