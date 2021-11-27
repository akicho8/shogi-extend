set :slackistrano, -> {
  deploy_slack_webhook_url = YAML.load(`rails credentials:show`).fetch(fetch(:stage).to_s)["deploy_slack_webhook_url"]
  tp({deploy_slack_webhook_url: deploy_slack_webhook_url})
  {
    # channel: "#random",         # ← 効いてない
    # team: "automatic-agent",    # ← 効いてない

    # staging production のときだけ credentials から deploy_slack_webhook_url が取れるので動く
    webhook: deploy_slack_webhook_url,
  }
}
