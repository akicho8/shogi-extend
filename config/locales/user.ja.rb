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
