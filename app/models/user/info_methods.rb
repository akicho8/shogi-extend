class User
  module InfoMethods
    extend ActiveSupport::Concern

    def info
      {
        "ID"                => id,
        "名前"              => name,
        "名前確定日時"      => name_input_at&.to_fs(:distance),
        "メールアドレス"    => email,
        "プロバイダ"        => auth_infos.collect(&:provider).join(", "),
        # "Twitter URL"       => twitter_url,
        "ログイン回数"      => sign_in_count,
        "最終ログイン日時"  => current_sign_in_at&.to_fs(:distance),
        "登録日時"          => created_at&.to_fs(:distance),
        "IP"                => current_sign_in_ip,
        "タグ"              => permit_tag_list,
        # "自己紹介"          => description.truncate(64),
      }
    end
  end
end
