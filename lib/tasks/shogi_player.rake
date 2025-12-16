
namespace :shogi_player do
  desc "パッケージ版"
  task :install do
    Rake::Task["shogi_player:install:package"].invoke
  end

  namespace :install do
    def install_shogi_player(version)
      cmd = "(cd ~/src/shogi-extend/nuxt_side; npm remove shogi-player; npm install #{version}; npm run clean)"
      puts cmd
      system cmd
    end

    # rake shogi_player:install:develop
    desc "開発版"
    task :develop do
      install_shogi_player("github:akicho8/shogi-player#develop")
    end

    desc "安定版"
    task :master do
      install_shogi_player("github:akicho8/shogi-player#master")
    end

    desc "パッケージ版"
    task :package do
      install_shogi_player("shogi-player")
    end
  end
end
