module QuickScript
  concern :OrderMod do
    class_methods do
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
  end
end
