module QuickScript
  module Chore
    class GroupScript < Base
      self.title = "実験室"
      self.description = "グループ一覧を表示する"
      self.parent_link = { force_link_to: "/" }

      def call
        rows = all.collect do |e|
          {
            "グループ" => { _nuxt_link: { name: e.name, to: { path: e.qs_path }, }, },
          }
        end
        simple_table(rows, always_table: true)
      end

      def all
        @all ||= yield_self do
          all = QsGroupInfo.values
          # if Rails.env.development?
          # else
          all = all.reject { |e| e.admin_only && !admin_user }
          # end
          all
        end
      end
    end
  end
end
