desc "nuxt_side 側のテスト"
task "jest" do
  system "cd nuxt_side && jest"
end

task "spec" do
  Rake::Task["jest"].invoke
end

task "shogi_player_development_version_update" do
  system "(cd ~/src/shogi-extend/nuxt_side; pnpm remove shogi-player; pnpm add -D github:akicho8/shogi-player#develop)"
end

task "shogi_player_production_version_update" do
  system "(cd ~/src/shogi-extend/nuxt_side; pnpm remove shogi-player; pnpm add -D shogi-player"
end
