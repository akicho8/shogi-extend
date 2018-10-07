################################################################################ 実験

desc "cap production env"
task :env do
  on roles(:all) do
    execute :env
  end
end
# before "deploy:check", "deploy:check:env"

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
