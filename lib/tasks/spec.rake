if defined?(RSpec)
  namespace :spec do
    desc "棋譜変換のテスト(KIFU_EXTRACTOR_OUTPUT=1 で expected を生成)"
    RSpec::Core::RakeTask.new("kifu_extractor") do |t|
      t.pattern = "spec/models/kifu_extractor_spec.rb"
      t.rspec_opts = "-f d"
    end

    desc "モデルのテスト(最初のエラーで止まる)"
    RSpec::Core::RakeTask.new(:core) do |t|
      t.pattern = "spec/models/**/*_spec.rb"
      t.rspec_opts = "-f p --fail-fast"
    end

    desc "モデルのテスト(失敗したテストの続きから実行する)"
    RSpec::Core::RakeTask.new(:core_next) do |t|
      t.pattern = "spec/models/**/*_spec.rb"
      t.rspec_opts = "-f p --fail-fast --only-failures"
    end

    desc "将棋ウォーズのモデルのテストすべて"
    RSpec::Core::RakeTask.new(:swars) do |t|
      t.pattern = "spec/models/swars/**/*_spec.rb"
      t.rspec_opts = "-f p"
    end

    namespace :swars do
      desc "プレイヤー情報のテスト"
      RSpec::Core::RakeTask.new(:user_stat) do |t|
        t.pattern = "spec/models/swars/user/stat/*_spec.rb"
        t.rspec_opts = "-f p"
      end
    end
  end
end
