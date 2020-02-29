# 組み込みスクリプトの本体
#
# ▼POSTタイプのときにsubmitする前の段階で何か実行させるには？
#
#   def show_action
#     unless target_record.group_info
#       c.redirect_to(script_link_path(:id => :dynamic_page_group_script))
#     end
#     super
#   end
#
# ▼script_bodyの中から他のクラスに委譲するには？
#
#   DynamicPageGroupScript.new(:current_user => current_user, :view_context => view_context, :controller => controller).script_body
#   または
#   DynamicPageGroupScript.new(@org_params).script_body
#
# ▼post後に別のところにリダイレクトするには？
#
#   def post_redirect_path(redirect_params)
#     script_link_path(:id => :oshirase_search_script)
#   end
#
module MyScript
  class Base < Soul
    class << self
      def url_prefix
        [:view_support, :my_script]
      end
    end
  end
end
