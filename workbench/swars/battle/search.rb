require "./setup"
Swars::Battle.search(query_info: QueryInfo.parse("手数:<=1")).count # => 5836
