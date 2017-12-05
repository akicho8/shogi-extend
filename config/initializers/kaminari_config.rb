# frozen_string_literal: true
Kaminari.configure do |config|
  if Rails.env.development? || Rails.env.test?
    config.default_per_page = 10
  else
    config.default_per_page = 50
  end
  # config.max_per_page = nil
  config.window = 1             # 左右1個
  config.outer_window = 1       # 端から1個
  # config.left = 0
  # config.right = 0
  # config.page_method_name = :page
  # config.param_name = :page
  config.params_on_first_page = true
end
