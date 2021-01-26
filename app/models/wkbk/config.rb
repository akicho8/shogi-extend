module Wkbk
  Config = {
    # -------------------------------------------------------------------------------- 問題作成フォーム
    :hint_enable             => false, # ヒントカラムを有効にする？
    :save_and_back_to_index  => true,  # 「保存」したら一覧に戻る？
    :difficulty_level_max    => 5,     # ★の最大数
    :time_limit_sec_enable   => false, # 時間制限のカラムを有効にする？
    :difficulty_level_enable => false, # 難易度カラムを表示する？
    :turm_max_limit          => 3,     # 手数制限

    # -------------------------------------------------------------------------------- API
    :api_articles_fetch_per  => 5,  # 問題一覧での1ページあたりの表示件数
    :api_books_fetch_per     => 5,  # 問題一覧での1ページあたりの表示件数
  }

  if Rails.env.staging? || Rails.env.production?
    Config.update({
                    :api_articles_fetch_per => 50,       # 問題一覧での1ページあたりの表示件数
                    :api_books_fetch_per    => 50,       # 問題一覧での1ページあたりの表示件数
                  })
  end
end
