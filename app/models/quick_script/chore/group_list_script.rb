module QuickScript
  module Chore
    class GroupListScript < Base
      self.title = "簡易ツール"
      self.description = "グループ一覧を表示する"

      def call
        all.collect do |e|
          {
            :name => { _nuxt_link: { name: e.name, to: { path: e.link_path }, }, },
          }
        end
      end

      private

      def all
        @all ||= yield_self do
          all = SgroupInfo.values
          if Rails.env.local?
          else
            all = all.reject { |e| e.admin_only && !admin_user }
          end
          all
        end
      end
    end
  end
end
