module QuickScript
  module Chore
    class IndexScript < Base
      self.title = "Index"
      self.description = "スクリプトの一覧を表示する"

      def call
        if params[:sgroup_index]
          return params.inspect
        else
          if all.empty?
            return "ここにはなんもありません"
          end

          rows = all.sort_by { |e|
            [e.sgroup_info, e.title]
          }.collect do |e|
            {
              :name        => { _nuxt_link: { name: e.title, to: { path: e.link_path }, }, },
              :description => e.description,
              :qs_group      => { _nuxt_link: { name: e.sgroup_info.name, to: { path: e.sgroup_info.link_path }, }, },
            }
          end

          if sgroup_infos.one?
            rows = rows.collect { |e| e.except(:qs_group) }
          end

          rows
        end
      end

      private

      def all
        @all ||= yield_self do
          all = Main.all
          if params[:sgroup_only]
            all = all.find_all { |e| e.qs_group == params[:sgroup_only] }
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

      def primary_qs_group
        if sgroup_infos.one?
          sgroup_infos.first
        end
      end

      def title
        if primary_qs_group
          primary_qs_group.name
        else
          super
        end
      end
    end
  end
end
