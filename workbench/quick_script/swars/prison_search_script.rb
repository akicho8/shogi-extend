require "./setup"
tp QuickScript::Swars::PrisonSearchScript.new(query: "十段").as_json # => {:body=>{:_component=>"QuickScriptViewValueAsTable", :paginated=>true, :total=>0, :current_page=>1, :per_page=>1000, :rows=>[]}, :qs_page_key=>nil, :button_label=>"検索", :params_add_submit_key=>nil, :form_parts=>[{:label=>"検索文字列", :key=>:query, :type=>:string, :default=>"十段"}], :__received_params__=>{:query=>"十段"}, :form_method=>:get, :flash=>{}, :meta=>{:title=>"将棋ウォーズ囚人検索", :description=>"検察結果を直近順に表示する", :og_image_key=>nil}, :redirect_to=>nil}
# >> |-----------------------+-------------------------------------------------------------------------------------------------------------------------|
# >> |                  body | {:_component=>"QuickScriptViewValueAsTable", :paginated=>true, :total=>0, :current_page=>1, :per_page=>1000, :rows=>[]} |
# >> |           qs_page_key |                                                                                                                         |
# >> |          button_label | 検索                                                                                                                    |
# >> | params_add_submit_key |                                                                                                                         |
# >> |            form_parts | [{:label=>"検索文字列", :key=>:query, :type=>:string, :default=>"十段"}]                                                |
# >> |   __received_params__ | {:query=>"十段"}                                                                                                        |
# >> |           form_method | get                                                                                                                     |
# >> |                 flash | {}                                                                                                                      |
# >> |                  meta | {:title=>"将棋ウォーズ囚人検索", :description=>"検察結果を直近順に表示する", :og_image_key=>nil}                        |
# >> |           redirect_to |                                                                                                                         |
# >> |-----------------------+-------------------------------------------------------------------------------------------------------------------------|
