p ["#{__FILE__}:#{__LINE__}", __method__, ]
# require "database_cleaner"

RSpec.configure do |config|
  # 最初の describe で必ず呼ばれる。これをデフォルトにする
  config.before(:context) do
    tp({default: :transaction})
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:transaction)
  end

  # SystemTest の場合はこれが「あと」に呼ばれるので truncation が有効になる
  config.before(:context, type: :system) do
    tp({system: :truncation})
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:example) do |ex|
    DatabaseCleaner.cleaning { ex.run }
  end
end
