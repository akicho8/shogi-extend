module QuickScript
  module Chore
    class IndexScript < Base
      self.title = "一覧"

      def call
        if all.empty?
          return "ここにはなんもありません"
        end

        rows = all.collect do |e|
          {
            :name        => { _nuxt_link: { name: e.title, to: { path: e.link_path }, }, },
            :description => e.description,
            :sgroup   => { _nuxt_link: { name: e.sgroup_info.name, to: { path: e.sgroup_info.link_path }, }, },
          }
        end

        if sgroup_infos.one?
          rows = rows.collect { |e| e.except(:sgroup) }
        end

        rows
      end

      private

      def all
        @all ||= yield_self do
          all = Main.all
          if params[:sgroup_only]
            all = all.find_all { |e| e.sgroup == params[:sgroup_only] }
          end
          if Rails.env.local?
          else
            all = all.reject { |e| e.sgroup_info.admin_only && !admin_user }
          end
          all
        end
      end

      def sgroup_infos
        @sgroup_infos ||= all.collect(&:sgroup_info).uniq
      end

      def primary_sgroup
        if sgroup_infos.one?
          sgroup_infos.first
        end
      end

      def title
        if primary_sgroup
          primary_sgroup.name
        else
          super
        end
      end
    end
  end
end
