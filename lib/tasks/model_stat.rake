if defined?(RSpec)
  task :model_stat => "model_stat:all"

  namespace :model_stat do
    desc "テストがないモデルを抽出する (全体) TARGET=xxx"
    task "all" => :environment do
      ModelStat.new(target: ENV["TARGET"]).call
    end

    desc "テストがないモデルを抽出する (quick_script 以下)"
    task "quick_script" do
      ModelStat.new(target: "quick_script").call
    end

    desc "テストがないモデルを抽出する (user_stat 以下)"
    task "user_stat" do
      ModelStat.new(target: "user_stat").call
    end
  end
end
