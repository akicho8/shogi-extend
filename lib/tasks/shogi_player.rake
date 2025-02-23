namespace :shogi_player do
  desc "パッケージ版"
  task :install do
    Rake::Task["shogi_player:install:package"].invoke
  end

  namespace :install do
    def install_shogi_player(version)
      cmd = "(cd ~/src/shogi-extend/nuxt_side; pnpm remove shogi-player; pnpm add -D #{version})"
      puts cmd
      system cmd
    end

    desc "開発版"
    task :develop do
      install_shogi_player("github:akicho8/shogi-player#develop")
    end

    desc "安定版"
    task :main do
      install_shogi_player("github:akicho8/shogi-player#main")
    end

    desc "パッケージ版"
    task :package do
      install_shogi_player("shogi-player")
    end
  end
end
