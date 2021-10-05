if defined?(DatabaseCleaner)
  RSpec.configure do |config|
    config.before(:suite) do
      # DbCop.foreign_key_checks_disable
    end

    # デフォルト
    config.before(:context) do
      # tp :transaction
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:transaction)
    end

    # SystemTest の場合はこれが「あと」に呼ばれるので truncation が有効になる
    config.before(:context, type: :system) do
      # tp :truncation
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.clean_with(:truncation)
    end

    config.around(:example) do |ex|
      DatabaseCleaner.cleaning { ex.run }
    end
  end
end
