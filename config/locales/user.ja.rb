{
  ja: {
    attributes: {},
    helpers: {
      submit: {
        battle: {},
      },
    },
    activerecord: {
      errors: {
        models: {
          user: {
            attributes: {
              email: {
                taken: "の %{value} がすでに登録されています。前回と別の方法でログインしようとしているのかもしれません。たとえば前回は Twitter でログインしたのに今回 Google でログインしようとしているなど。もし、SNS経由でログインした覚えがまったくない場合は「面倒なログイン」からメールアドレスとパスワードでログインしよう。パスワードも忘れた場合は「パスワードを忘れた」から再発行しよう。ちょっと何言ってるかわからない状態であれば Twitter で @sgkinakomochi に問い合わせよう。",
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
          # :description => "自己紹介",
          # :twitter_key => "Twitterアカウント",
        },
      },
    },
  },
}
