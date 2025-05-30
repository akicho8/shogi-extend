require "./setup"

QueryInfo.parse("foo:>=").lookup_one(:foo)   # => ">="
QueryInfo.parse("foo:>=-1").lookup_one(:foo) # => {operator: :gteq, value: -1}
QueryInfo.parse("foo:>=1").lookup_one(:foo)  # => {operator: :gteq, value: 1}
QueryInfo.parse("foo:>").lookup_one(:foo)    # => ">"
QueryInfo.parse("foo:>-1").lookup_one(:foo)  # => {operator: :gt, value: -1}
QueryInfo.parse("foo:>1").lookup_one(:foo)   # => {operator: :gt, value: 1}
QueryInfo.parse("foo:=").lookup_one(:foo)    # => "="
QueryInfo.parse("foo:==1").lookup_one(:foo)  # => {operator: :eq, value: 1}
QueryInfo.parse("foo:!=1").lookup_one(:foo)  # => {operator: :not_eq, value: 1}

QueryInfo.parse("foo tag:a")    # => #<QueryInfo:0x0000000125b11950 @options={available_keys: nil}, @query="foo tag:a", @cache={}, @attributes={tag: ["a"]}, @values=["foo"], @urls=[]>
QueryInfo.parse("id:1,2,3").lookup_first([:ids, :id]) # => ["1", "2", "3"]

QueryInfo.parse("").lookup(:foo) # => nil
QueryInfo.parse("foo:>1 foo:>2").lookup(:foo) # => [{operator: :gt, value: 1}, {operator: :gt, value: 2}]
QueryInfo.parse("foo:1 foo:2").lookup(:foo) # => ["1", "2"]

QueryInfo.parse("xxxxxxxxxx").swars_user_key # => <xxxxxxxxxx>
QueryInfo.parse("xxxxxxxxxx").swars_user     # => nil

QueryInfo.parse("BOUYATETSU5").swars_user_key # => <BOUYATETSU5>
QueryInfo.parse("BOUYATETSU5").swars_user     # => #<Swars::User id: 228939, user_key: "BOUYATETSU5", grade_id: 4, last_reception_at: "2025-05-05 17:01:37.000000000 +0900", search_logs_count: 2552, created_at: "2020-05-05 20:42:36.000000000 +0900", updated_at: "2025-05-05 17:01:37.000000000 +0900", ban_at: nil, latest_battled_at: "2025-04-25 16:55:03.000000000 +0900", soft_crawled_at: "2025-05-05 17:01:37.000000000 +0900", hard_crawled_at: "2024-11-27 06:27:44.000000000 +0900">

QueryInfo.parse("棒銀").tactic_items.sole.name # => "棒銀"
QueryInfo.parse("初段").grade_infos.sole.name # => "初段"
