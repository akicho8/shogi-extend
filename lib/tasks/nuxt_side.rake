desc "nuxt_side 側のテスト"
task "jest" do
  system "cd nuxt_side && jest"
end

task "spec" do
  Rake::Task["jest"].invoke
end

namespace :nuxt_side do
  namespace :pnpm do
    # rake nuxt_side:pnpm:reset
    desc "pnpm で nuxt_side/node_modules を作り直す"
    task :reset do
      system "rm -rf $(pnpm store path)" # rm -rf /Users/ikeda/Library/pnpm/store/v3
      system "cd nuxt_side && rm -fr node_modules && pnpm install" # pnpm update --force
      system "cd nuxt_side && pnpm install"                        # これで成功する場合がある
    end
  end

  namespace :npm do
    # rake nuxt_side:npm:reset
    desc "npm で nuxt_side/node_modules を作り直す"
    task :reset do
      system "cd nuxt_side && rm -fr node_modules && npm install"
    end

    # rake nuxt_side:npm:update
    desc "更新できるパッケージを確認する"
    task :update do
      system "cd nuxt_side && npx npm-check -u"
    end
  end
end
