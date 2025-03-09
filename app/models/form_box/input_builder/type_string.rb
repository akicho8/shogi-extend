module FormBox
  module InputBuilder
    class TypeString < Base
      def input_tag
        :text_field_tag
      end

      def tag_build
        h.send(input_tag, key, default, form_controll)
      end

      def form_controll
        super.merge({
            :autocomplete => "on", # Google Chrome で iCloud パスワードを有効にすると自動入力候補が出なくなるため明示的に指定してみる
          })
      end
    end
  end
end
