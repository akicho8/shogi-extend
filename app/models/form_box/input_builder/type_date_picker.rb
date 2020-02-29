module FormBox
  module InputBuilder
    class TypeDatePicker < TypeString
      def form_controll
        super.merge("data-datepicker" => true)
      end

      # to_s はハイフン区切りだけど datepicker はスラッシュ区切りなので統一する
      def default
        if s = super.presence
          Date::DATE_FORMATS[:date_picker_format] ||= "%Y/%m/%d" # ハイフン区切りは datepicker でパースできないため
          Date.parse(s.to_s, false).to_s(:date_picker_format)
        end
      end
    end
  end
end
