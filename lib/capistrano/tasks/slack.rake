set :slackistrano, -> {
  {
    # channel: "#random",         # ← 効いてない
    # team: "automatic-agent",    # ← 効いてない
    webhook: YAML.load(`rails credentials:show`).fetch("deploy_slack_webhook_url").fetch(fetch(:stage).to_s),
  }
}
