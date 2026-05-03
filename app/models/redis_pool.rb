class RedisRegistry
  def initialize
    @pools = {}
  end

  def client(db_number)
    @pools[db_number] ||= pool_create(db_number)
  end

  private

  def pool_create(db_number)
    unless db_number.kind_of? Integer
      raise ArgumentError, db_number.inspect
    end
    config = RedisClient.config(host: "127.0.0.1", db: db_number, reconnect_attempts: 3)
    config.new_pool(size: Integer(ENV.fetch("RAILS_MAX_THREADS", 3))) # ../../config/puma.rb の RAILS_MAX_THREADS の初期値と合わせる
  end
end

RedisPool = RedisRegistry.new
