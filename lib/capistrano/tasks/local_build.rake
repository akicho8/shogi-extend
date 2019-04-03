unless ENV["REMOTE_BUILD"] == "1"
  # cap production deploy:assets:precompile

  # 元のタスクの内容は消しておく
  Rake::Task["deploy:assets:precompile"].clear

  # yarn も実行する必要がない
  Rake::Task["yarn:install"].clear

  # 新しく定義
  desc "ローカルで assets:precompile してコピー"
  task "deploy:assets:precompile" do
    tmpdir = "/tmp/__repository_#{fetch(:application)}_#{fetch(:stage)}"

    run_locally do
      execute :rm, "-fr #{tmpdir}"
      execute "git clone #{fetch(:repo_url)} --depth 1 --branch #{fetch(:branch)} #{tmpdir}"
      within tmpdir do
        # database.yml はなくてもいいはずだけど assets:precompile を実行するタイミングで
        # initializers/* のなかでDBアクセスしてしまったりすることもあるので
        # database.yml がない場合は必要に応じても用意する
        # この例ではプリコンパイル時専用の database.precompile.yml を config/database.yml としています
        execute :cp, "-v", "config/database.precompile.yml", "config/database.yml"

        # master.key も必要に応じてコピーする
        execute :cp, "-v", "#{__dir__}/../../../config/master.key", "config"

        # ないとは思うけどもし NODE_ENV=production な環境でビルドするときは
        # devDependencies が対象にならないので --production=false の引数をつけとくといい
        execute :yarn

        # 環境変数 STAGE, NODE_ENV, RAILS_ENV を有効にしておく
        with stage: fetch(:stage), rails_env: fetch(:rails_env), node_env: fetch(:rails_env) do
          # sh -c で実行しているのはデプロイ先の rbenv 関連プレフィクスをつけたくないため
          # このあたりちょっとややこしい
          execute :sh, "-c 'pwd && env | grep ENV'"
          execute :sh, "-c 'bundle exec rails -t assets:precompile'"
        end
      end

      # public/{assets,packs} をデプロイ先に転送
      within "#{tmpdir}/public" do
        roles(:web).each do |e|
          execute :rsync, "-au --delete -e ssh assets packs #{e.user}@#{e.hostname}:#{release_path}/public"
        end
      end
      execute :rm, "-fr #{tmpdir}"
    end
  end
end
