if defined?(Kaminari)
  Kaminari.configure do |config|
    config.default_per_page = 10
    config.max_per_page = 50
    # config.max_per_page = nil
    config.window = 1             # 左右1個
    config.outer_window = 1       # 端から1個
    # config.left = 0
    # config.right = 0
    # config.page_method_name = :page
    # config.param_name = :page
    config.params_on_first_page = true
  end
end
