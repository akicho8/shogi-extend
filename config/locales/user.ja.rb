{
  ja: {
    attributes: {
    },
    helpers: {
      submit: {
        battle: {
        },
      },
    },
    activerecord: {
      errors: {
        models: {
          user: {
            attributes: {
              email: {
                taken: "の値 %{value} が重複しています。以前に別の方法でログインしているのかもしれません。例えばTwitter経由でログインしたのにGoogle経由でログインしようとしているなど。SNS経由でログインした覚えがない場合は「面倒なログイン」からメールアドレスとパスワードでログインしてください。パスワードを忘れた場合は「パスワードを忘れた」から再発行してください",
              },
            },
          },
        },
      },
      models: {
        user: "ユーザー",
      },
      attributes: {
        user: {
          :name                  => "名前",
          :avatar                => "アバター",
          :email                 => "メールアドレス",
          :password              => "パスワード",
          :password_confirmation => "確認用パスワード",
          :race_key              => "種族",
        },
        profile: {
          :description => "自己紹介",
          :twitter_key => "Twitterアカウント",
        },
      },
    },
  },
}
