module SbSupportMethods
  def black_king_move_up;   piece_move_o("59", "58", "☗5八玉"); end # 1手目
  def white_king_move_up;   piece_move_o("51", "52", "☖5二玉"); end # 2手目
  def black_king_move_down; piece_move_o("58", "59", "☗5八玉"); end # 3手目
  def white_king_move_down; piece_move_o("52", "51", "☖5一玉"); end # 4手目

  # 1, 2 手目
  def king_move_up
    black_king_move_up
    white_king_move_up
  end

  # 3, 4 手目
  def king_move_down
    black_king_move_down
    white_king_move_down
  end

  # 1, 2, 3, 4 手目
  def king_move_up_down
    king_move_up
    king_move_down
  end

  # 4 * 3 + 1 手目
  def perpetual_trigger
    king_move_up_down
    king_move_up_down
    king_move_up_down
    black_king_move_up # 4回目の同一局面でモーダルが発動する
  end
end
