module QuickScript
  concern :MetaMod do
    prepended do
      class_attribute :title, default: nil
      class_attribute :description, default: nil
      class_attribute :og_image_key, default: nil
    end

    class_methods do
      def short_title
        title.to_s.remove(/\A#{qs_group_info.name}\s*/) # "将棋ウォーズ囚人検索" => "囚人検索"
      end

      def ordered_index
        @ordered_index ||= yield_self do
          index = Float::INFINITY
          if av = "quick_script/#{qs_group_key}/ordered_index".classify.safe_constantize
            if i = av.index(self)
              index = i
            end
          end
          index
        end
      end
    end

    def as_json(*)
      super.merge(meta: meta)
    end

    private

    def meta
      {
        :title        => title,
        :description  => description,
        :og_image_key => og_image_key,
      }
    end
  end
end
