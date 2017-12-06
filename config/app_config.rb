AppConfig = {
  app_name: "将棋のツール（仮）",
  run_localy: Rails.env.test? || ["RUN_LOCALY", "L", "MOCK", "M"].any? { |e| ENV[e].to_s.in?(["1", "true"]) },
}
