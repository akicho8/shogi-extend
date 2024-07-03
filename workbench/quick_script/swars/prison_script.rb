require "./setup"
QuickScript::Swars::PrisonScript.new(query: "十段").call # => {:_component=>"QuickScriptShowValueAsTable", :paginated=>true, :total=>0, :current_page=>1, :per_page=>1000, :rows=>[]}
