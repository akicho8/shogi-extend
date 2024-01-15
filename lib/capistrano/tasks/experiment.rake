################################################################################ 実験

desc "cap production env"
task :env do
  on roles(:all) do
    execute :env
  end
end

task :t do
  on roles(:all) do
    within "/tmp" do
      execute "pwd"
    end
  end
end

task :pwd do
  on roles(:all) do
    execute :bundle, "exec pwd"
  end
end

task :v do
  on roles(:all) do
    tp({
        current_path: current_path,
        release_path: release_path,
        'fetch(:current_path)': fetch(:current_path),
        'fetch(:release_path)': fetch(:release_path),
      })
  end
end

desc "bin/se の実行 (COMMAND=xxx)"
task :se do
  on roles(:all) do
    within current_path do
      execute "bin/se", ENV["COMMAND"]
    end
  end
end

namespace :rails do
  desc "Run Rails console"
  task :console2 do
    run_interactively primary(:app) do
      within current_path do
        # as user: :alice do
        execute(:rails, :console)
        # end
      end
    end
  end
end
