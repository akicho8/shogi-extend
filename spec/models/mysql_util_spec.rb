require "rails_helper"

RSpec.describe MysqlUtil, type: :model do
  it "mysql_convert_tz_with_time_zone_validate!" do
    MysqlUtil.mysql_convert_tz_with_time_zone_validate!
  end

  it "column_tokyo_timezone_cast!" do
    assert2 { MysqlUtil.column_tokyo_timezone_cast("foo") == "CONVERT_TZ(foo, 'UTC', 'Asia/Tokyo')" }
  end
end
