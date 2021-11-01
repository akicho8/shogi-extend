{
  ja: {
    attributes: {
    },
    helpers: {
      submit: {
      },
    },
    activemodel: {
      models: {
      },
    },
    activerecord: {
      models: {
        "kiwi/lemon"  => "動画",
        "kiwi/banana" => "ライブラリ",
      },
      attributes: {
        "kiwi/banana" => {
          :lemon_id              => "動画ファイル",
          :user_id               => "所有者",
          :folder_id             => "公開設定",
          :thumbnail_pos         => "サムネ位置(秒)",
          :banana_messages_count => "コメント数",
          :access_logs_count     => "アクセス数",
        },
        "kiwi/lemon" => {
          :user_id          => "所有者",
          :recordable_type  => "棋譜情報(クラス名)",
          :recordable_id    => "棋譜情報",
          :all_params       => "変換用全パラメータ",
          :process_begin_at => "開始日時",
          :process_end_at   => "終了日時(失敗時も入る)",
          :successed_at     => "正常終了日時",
          :errored_at       => "失敗終了日時",
          :error_message    => "エラー文言",
          :content_type     => "動画タイプ",
          :file_size        => "動画サイズ",
          :ffprobe_info     => "ffprobeの内容",
          :browser_path     => "動画WEBパス",
          :filename_human   => "動画の人間向けファイル名",
        },
      },
    },
  },
}
