module MysqlToolkit
  extend self

  def mysql_convert_tz_with_time_zone_validate!
    if !ApplicationRecord.connection.select_value("SELECT CONVERT_TZ(now(), 'UTC', 'Asia/Tokyo')")
      raise "mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -u root mysql を実行しよう"
    end
  end

  def column_tokyo_timezone_cast(column)
    "CONVERT_TZ(#{column}, 'UTC', 'Asia/Tokyo')"
  end
end
