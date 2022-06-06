require "pathname"
require "table_format"
log_file = Pathname("log/production.log").expand_path
body = log_file.read
body = body.gsub("153.127.31.7", "PRODUCTION_SELF")
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
# >> |-----------------+-------+--------------------------------------------------------------------------------------|
# >> | ip              | count | name                                                                                 |
# >> |-----------------+-------+--------------------------------------------------------------------------------------|
# >> | 66.249.79.54    | 13818 | OrgName:        Google LLC                                                           |
# >> | 66.249.79.57    |  3170 | OrgName:        Google LLC                                                           |
# >> | 6.0.3.2         |   854 | OrgName:        Headquarters, USAISC                                                 |
# >> | 66.249.79.60    |   330 | OrgName:        Google LLC                                                           |
# >> | 126.246.173.151 |   259 | netname:        BBTEC                                                                |
# >> | 18.183.60.100   |   107 | OrgName:        Amazon Technologies Inc.\nOrgName:        Amazon Data Services Japan |
# >> | 121.119.43.206  |    88 | netname:        OCN\nnetname:        PLALA                                           |
# >> | 18.183.15.35    |    64 | OrgName:        Amazon Technologies Inc.\nOrgName:        Amazon Data Services Japan |
# >> | 106.154.2.173   |    60 | netname:        KDDI\nnetname:        KDDI-NET                                       |
# >> | 127.0.0.1       |    55 |                                                                                      |
# >> |-----------------+-------+--------------------------------------------------------------------------------------|
