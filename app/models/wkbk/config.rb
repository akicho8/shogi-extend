module Wkbk
  Config = {
    :api_articles_fetch_per                    => 50,    # 問題一覧での1ページあたりの表示件数
    :api_books_fetch_per                       => 50,    # 問題集一覧での1ページあたりの表示件数
    :black_piece_zero_check_on_function_enable => false, # 「詰将棋」なら先手の駒が余っていないことを確認するか？(駒余りを正解に含めるとエラーになるため不便)
    :mate_validate_on_function_enable          => true,  # 詰将棋系なら詰んでいることを確認(※無駄合いがチェックできないので不便)
  }
end
