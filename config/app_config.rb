AppConfig = {
  app_name: "将棋のツール（仮）",
  mock_enable: Rails.env.test? || ENV["MOCK"].present? || ENV["M"].present?,
}
