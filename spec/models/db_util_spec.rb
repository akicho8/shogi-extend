require "rails_helper"

RSpec.describe DbUtil, type: :model do
  it "mysql_convert_tz_with_time_zone_validate!" do
    DbUtil.mysql_convert_tz_with_time_zone_validate!
  end

  it "tz_adjust!" do
    assert { DbUtil.tz_adjust("foo") == "CONVERT_TZ(foo, 'UTC', 'Asia/Tokyo')" }
  end
end
