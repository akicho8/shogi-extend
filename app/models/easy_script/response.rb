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
# ▼post後に別のところにリダイレクトするには？
#
#   def post_redirect_path(redirect_params)
#     script_link_path(:id => :foo)
#   end
#
module EasyScript
  class Response < Hash
    def to_result_label
      if time_label && bm_ms_str
        "#{time_label}の実行結果(#{bm_ms_str})"
      else
        "実行結果"
      end
    end

    private

    def time_label
      if self[:time]
        self[:time].to_time.to_s(:exec_distance)
      end
    end

    def bm_ms_str
      if self[:bm_ms]
        "%.1f ms" % self[:bm_ms]
      end
    end
  end
end
