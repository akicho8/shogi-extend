if defined?(Kaminari)
  Kaminari.configure do |config|
    config.default_per_page     = 10

    # ../../nuxt_side/components/Swars/SwarsBattleIndex/models/per_info.js と合わせること
    config.max_per_page         = 200

    config.window               = 1 # 左右1個
    config.outer_window         = 1 # 端から1個

    # config.left               = 0
    # config.right              = 0
    # config.page_method_name   = :page
    # config.param_name         = :page

    # paginate が表示する最初のページへのリンクはすべての params を無視していたが、
    # 他のパラメータまでなくなってしまうという問題に対応するオプション
    # https://qiita.com/yuki24/items/aab0d8e417d6fe546688#params_on_first_page-%E3%82%AA%E3%83%97%E3%82%B7%E3%83%A7%E3%83%B3%E3%81%AE%E8%BF%BD%E5%8A%A0
    config.params_on_first_page = true
  end
end
