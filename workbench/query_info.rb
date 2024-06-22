require "./setup"

QueryInfo.parse("foo:>=").lookup_one(:foo)   # => ">="
QueryInfo.parse("foo:>=-1").lookup_one(:foo) # => {:operator=>:gteq, :value=>-1}
QueryInfo.parse("foo:>=1").lookup_one(:foo)  # => {:operator=>:gteq, :value=>1}
QueryInfo.parse("foo:>").lookup_one(:foo)    # => ">"
QueryInfo.parse("foo:>-1").lookup_one(:foo)  # => {:operator=>:gt, :value=>-1}
QueryInfo.parse("foo:>1").lookup_one(:foo)   # => {:operator=>:gt, :value=>1}
QueryInfo.parse("foo:=").lookup_one(:foo)    # => "="
QueryInfo.parse("foo:==1").lookup_one(:foo)  # => {:operator=>:eq, :value=>1}
QueryInfo.parse("foo:!=1").lookup_one(:foo)  # => {:operator=>:not_eq, :value=>1}
