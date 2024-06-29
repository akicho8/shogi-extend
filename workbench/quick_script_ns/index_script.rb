require "./setup"
QuickScriptNs::IndexScript.new.call # => [{:name=>"a", :url=>"http://example.com/"}, {:name=>"b", :url=>{:_nuxt_link=>{:name=>"a", :to=>{:name=>"script-id", :params=>{:id=>"calc"}}}}}, {:name=>"c", :url=>{:_nuxt_link=>{:name=>"b", :to=>{:path=>"script/calc"}}}}]
