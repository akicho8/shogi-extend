class LogLevelInfo
  include ApplicationMemoryRecord
  memory_record [
    { key: :emergency, help: "基本使わない",                                                             mail_notify: true,  slack_notify: true,  available_environments: [:test, :development, :staging, :production], },
    { key: :alert,     help: "1回発生したら必ずなにかしらの対応が必要なもの",                            mail_notify: true,  slack_notify: true,  available_environments: [:test, :development, :staging, :production], },
    { key: :critical,  help: "基本的には1回発生したら対応や調査が必要なもの",                            mail_notify: true,  slack_notify: true,  available_environments: [:test, :development, :staging, :production], },
    { key: :important, help: "重要",                                                                     mail_notify: true,  slack_notify: true,  available_environments: [:test, :development, :staging, :production], },
    { key: :error,     help: "システムが原因で正常に処理ができないが、頻発しなければ未対応でもいいもの", mail_notify: true,  slack_notify: true,  available_environments: [:test, :development, :staging, :production], },
    { key: :warning,   help: "ユーザー起因で正常に処理ができなかったようなもの",                         mail_notify: true,  slack_notify: true,  available_environments: [:test, :development, :staging, :production], },
    { key: :notice,    help: "正常に処理しているが、記録しておきたい重要なもの",                         mail_notify: false, slack_notify: true,  available_environments: [:test, :development, :staging, :production], },
    { key: :info,      help: "そこまで重要じゃないが記録しておきたいもの",                               mail_notify: false, slack_notify: false, available_environments: [:test, :development, :staging, :production], },
    { key: :debug,     help: "開発のデバッグ時に必要な情報",                                             mail_notify: false, slack_notify: false, available_environments: [:test, :development,                      ], },
    { key: :trace,     help: "最も詳細なメッセージを含むログ",                                           mail_notify: false, slack_notify: false, available_environments: [:test, :development,                      ], },
  ]

  def available_environments
    @available_environments ||= super.to_set
  end

  def to_app_log_attributes
    {
      :level        => key,
      :slack_notify => slack_notify,
      :mail_notify  => mail_notify,
    }
  end
end
