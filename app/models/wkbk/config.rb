module Wkbk
  Config = {
    :api_articles_fetch_per => 5,  # 問題一覧での1ページあたりの表示件数
    :api_books_fetch_per    => 5,  # 問題一覧での1ページあたりの表示件数
  }

  if Rails.env.staging? || Rails.env.production?
    Config.update({
                    :api_articles_fetch_per => 50,       # 問題一覧での1ページあたりの表示件数
                    :api_books_fetch_per    => 50,       # 問題一覧での1ページあたりの表示件数
                  })
  end
end
