RSpec.configure do |config|
  # *_spec.rb ロード後に実行する
  # このようにすれば
  #   around { |e| Timecop.return { e.run } }
  # として元に戻す処理を一カ所に書くことができる
  config.before(:suite) do
    Timecop.freeze("2000-01-01")
  end
end
