# 組み込みスクリプトの本体
#
# ▼POSTタイプのときにsubmitする前の段階で何か実行させるには？
#
#   def show_action
#     unless target_record.group_info
#       c.redirect_to(script_link_path(:id => :foo))
#     end
#     super
#   end
#
# ▼script_bodyの中から他のクラスに委譲するには？
#
#   FooScript.new(:current_user => current_user, :view_context => view_context, :controller => controller).script_body
#   または
#   FooScript.new(@org_params).script_body
#
module AtomicScript
  class Base
    include Core
    include ColumnsColumMethods
    include FormMethods
    include PageTitleMethods
    include SupportMethods
    include LinkMethods
    include AddParamsPrintMethods
    include VisibilityHiddenMethods

    # include PostRedirectMethods
  end
end
