namespace :notice do
  desc "デプロイ開始時に通知する"
  task "starting" do
    Say.call "#{fetch(:application)} #{fetch(:branch)} to #{fetch(:stage)}"
  end
  before "deploy:starting", "notice:starting"

  desc "デプロイ失敗時に伝える"
  task "failed" do
    Say.call "デプロイに失敗しました"
  end
  after "deploy:failed", "notice:failed"

  desc "デプロイ成功時に通知する"
  task "finished" do
    Say.call "デプロイに成功しました"
  end
  after "deploy:finished", "notice:finished"
end
