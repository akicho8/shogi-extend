module DbCop
  extend self

  def foreign_key_checks_disable
    c = connection
    c.execute("SET foreign_key_checks = 0")
    if block_given?
      begin
        yield c
      ensure
        foreign_key_checks_enable
      end
    end
  end

  def foreign_key_checks_enable
    connection.execute("SET foreign_key_checks = 1")
  end

  # def truncate(table_name)
  #   connection.execute("TRUNCATE #{table_name}")
  # end
  #
  def connection
    ApplicationRecord.connection
  end
end
