module FormBox
  module InputBuilder
    class TypeFile < TypeString
      def tag_build
        h.file_field_tag(key, form_controll)
      end

      def form_controll
        # if default.present?
        #   raise "ファイルフィールドの value に #{default} は指定しても無駄です"
        # end
        super.merge(:value => default).merge(params.slice(:multiple))
      end
    end
  end
end
