desc "デプロイが成功したタイミングでグラフ関連を転送する"
after "deploy:publishing", :r_generate do
  if fetch(:stage) == :production
    system "bundle exec rake r:generate DEPLOY=1"
  end
end
