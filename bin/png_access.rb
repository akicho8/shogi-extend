require "pathname"
require "table_format"
log_file = Pathname("log/production.log").expand_path
body = log_file.read
body = body.gsub("153.127.31.7", "PRODUCTION_SELF")
body = body.lines.grep(/GET.*png/).join
a = body.scan(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/)
ip_counts = a.group_by(&:itself).transform_values(&:size).sort_by { |k, v| -v }.take(10)
rows = ip_counts.collect { |ip, count|
  row = {}
  row[:ip] = ip
  row[:count] = count
  row[:name] = `whois #{ip}`.lines.grep(/OrgName|netname/).join.strip
  row
}
tp rows
# >> |----------------+-------+---------------------------------------------------|
# >> | ip             | count | name                                              |
# >> |----------------+-------+---------------------------------------------------|
# >> | 66.249.79.54   | 15135 | OrgName:        Google LLC                        |
# >> | 66.249.79.57   |  3373 | OrgName:        Google LLC                        |
# >> | 153.169.31.138   |   482 | netname:        OCN\nnetname:        OCN          |
# >> | 66.249.79.60   |   157 | OrgName:        Google LLC                        |
# >> | 106.154.2.173  |   128 | netname:        KDDI\nnetname:        KDDI-NET    |
# >> | 103.5.140.150  |    52 | netname:        WI2\nnetname:        WI2-SRV-NET  |
# >> | 121.81.181.132 |    48 | netname:        K-Opticom\nnetname:        OPTAGE |
# >> | 126.35.194.195 |    42 | netname:        BBTEC                             |
# >> | 123.226.191.17 |    37 | netname:        OCN\nnetname:        OCN          |
# >> | 133.206.58.64  |    14 | netname:        JPNIC-NET-JP-ERX                  |
# >> |----------------+-------+---------------------------------------------------|
