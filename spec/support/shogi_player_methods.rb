module ShogiPlayerMethods
  # 将棋盤内でプレイヤー名が表示されている
  def assert_has_sp_player_name
    assert_selector(".MembershipLocationPlayerInfoName")
  end

  # 将棋盤内で location_key 側のプレイヤー名は user_name になっている
  def assert_sp_player_name(location_key, user_name)
    assert_selector(".CustomShogiPlayer .Membership.is_#{location_key} .MembershipLocationPlayerInfoName", text: user_name, exact_text: true)
  end

  # ▲△の順に指定のプレイヤー名を表示している
  def assert_sp_player_names(black_name, white_name)
    assert_sp_player_name(:black, black_name)
    assert_sp_player_name(:white, white_name)
  end

  def sp_controller_click(klass)
    find(".CustomShogiPlayer .NavigateBlock .button.#{klass}").click
  end

  # 向き
  def assert_viewpoint(location_key)
    assert_selector(".CustomShogiPlayer.is_viewpoint_#{location_key}")
  end

  # from から to に移動する
  def piece_move(from, to)
    [from, to].each { |e| board_place(e).click }
  end

  def board_place(place)
    find(place_class(place))
  end

  def place_class(place)
    [".place", place.chars].join("_")
  end

  def stand_piece(location, piece)
    find(".Membership.is_#{location} .piece_#{piece}")
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
    assert_selector ".CustomShogiPlayer .MainBoard .PieceTexture.location_#{location_key}.promoted_#{promoted}.piece_name.piece_#{piece_key}"
  end
end
