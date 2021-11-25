set :slackistrano, {
  channel: "#exception",
  team: "automatic-agent",
  webhook: YAML.load(`rails credentials:show`, aliases: true).dig("slack_webhook_url"),
}
