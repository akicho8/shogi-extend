if defined?(DatabaseCleaner)
  RSpec.configure do |config|
    config.before(:suite) do |e|
      # tp AppLog
      # ForeignKey.disabled
    end

    # デフォルト
    config.before(:suite) do |e|
      # if e.metadata[:type] == :system
      # else
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
      # end
    end

    # # SystemTest の場合はこれが「あと」に呼ばれるので truncation が有効になる
    # config.before(:context, type: :system) do
    #   DatabaseCleaner.strategy = :truncation
    #   DatabaseCleaner.clean_with(:truncation)
    # end

    config.around(:example) do |e|
      if e.metadata[:type] == :system
        e.run
      else
        DatabaseCleaner.cleaning { e.run }
      end
    end
  end
end
