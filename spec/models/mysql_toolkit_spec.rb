require "rails_helper"

RSpec.describe MysqlToolkit, type: :model do
  it "mysql_convert_tz_with_time_zone_validate!" do
    MysqlToolkit.mysql_convert_tz_with_time_zone_validate!
  end

  it "column_tokyo_timezone_cast!" do
    assert { MysqlToolkit.column_tokyo_timezone_cast("foo") == "CONVERT_TZ(foo, 'UTC', 'Asia/Tokyo')" }
  end
end
