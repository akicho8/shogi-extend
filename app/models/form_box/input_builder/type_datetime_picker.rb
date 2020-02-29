module FormBox
  module InputBuilder
    class TypeDatetimePicker < TypeString
      def form_controll
         super.merge("data-datetimepicker" => true)
      end

      # なくてもいいけど +900 がついたりすると混乱するため綺麗にする
      def default
        if s = super.presence
          Time::DATE_FORMATS[:datetime_picker_format] ||= "%Y/%m/%d %R"
          Time.zone.parse(s.to_s).to_s(:datetime_picker_format)
        end
      end
    end
  end
end
