module DbCop
  extend self

  def mysql_convert_tz_with_time_zone_validate!
    unless ActiveRecord::Base.connection.select_all("SELECT CONVERT_TZ(now(), 'UTC', 'Asia/Tokyo')")
      raise "mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root mysql を実行してください"
    end
  end

  def tz_adjust(column)
    "CONVERT_TZ(#{column}, 'UTC', 'Asia/Tokyo')"
  end

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
