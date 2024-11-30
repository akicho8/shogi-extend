# |-------------------------------------------+----------------------------------------------------|
# | Code                                      | 意味                                               |
# |-------------------------------------------+----------------------------------------------------|
# | self.parent_link = { force_link_to: "/" } | 固定で / に移動する                                |
# | self.parent_link = nil                    | ブラウザバックする。外に出そうなら上の階層に上がる |
# | self.parent_link = { fallback_url: "/"  } | ブラウザバックする。外に出そうなら / に移動する    |
# |-------------------------------------------+----------------------------------------------------|
#
# ではあるが back_to を指定されたときが一番優先度が高い
#
# 関連
# vue_history.js
# parent_link_click_handle
# parent_link_script.rb

module QuickScript
  module Middleware
    concern :ParentLinkMod do
      prepended do
        class_attribute :parent_link, default: nil
      end

      def as_json(*)
        super.merge({
            :parent_link => back_to_or_parent_link,
          })
      end

      private

      def back_to_or_parent_link
        if v = params[:back_to].presence
          { force_link_to: v }
        else
          parent_link
        end
      end
    end
  end
end
