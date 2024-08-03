module QuickScript
  module Chore
    class SitemapScript < Base
      self.title = "SITEMAPの素"
      self.description = "SITEMAPの素を生成する"

      def call
        [
          *qs_group_info_path,
          *page_path_list,
        ]
      end

      def page_path_list
        all = Dispatcher.all
        all = all.find_all { |e| e.qs_group_info.sitemap }
        all = all.reject { |e| e.qs_group_info.admin_only }
        all = all.reject { |e| e.qs_invisible }
        all.collect { |e| e.qs_path }
      end

      def qs_group_info_path
        QsGroupInfo.find_all(&:sitemap).collect(&:qs_path)
      end
    end
  end
end
