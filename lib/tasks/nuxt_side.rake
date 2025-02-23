desc "nuxt_side 側のテスト"
task "jest" do
  system "cd nuxt_side && jest"
end

task "spec" do
  Rake::Task["jest"].invoke
end
