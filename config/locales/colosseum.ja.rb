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
          :joined_at             => "ロビーに入った日時",
          :online_at             => "オンラインになった日時",
          :fighting_at           => "入室しているなら入室日時",
          :matching_at           => "マッチング中(開始日時)",
          :lifetime_key          => "ルール・持ち時間",
          :team_key              => "ルール・人数",
          :self_preset_key       => "ルール・自分の手合割",
          :oppo_preset_key       => "ルール・相手の手合割",
          :robot_accept_key      => "CPUと対戦するかどうか",
          :user_agent            => "ブラウザ情報",
          :email                 => "メールアドレス",
          :password              => "パスワード",
          :password_confirmation => "確認用パスワード",
          :cpu_brain_key         => "CPUの思考タイプ",
          :race_key              => "種族",
        },
        profile: {
          :description => "自己紹介",
        },
      },
    },
  },
}
