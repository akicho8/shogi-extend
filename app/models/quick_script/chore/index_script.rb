module QuickScript
  module Chore
    class IndexScript < Base
      self.title = "Index"
      self.description = "スクリプトの一覧を表示する"

      def call
        if all.empty?
          return "ここにはなんもありません"
        end

        rows = all.sort_by { |e|
          [e.qs_group_info, e.title]
        }.collect do |e|
          {
            :name        => { _nuxt_link: { name: e.title, to: { path: e.link_path }, }, },
            :description => e.description,
            :qs_group_key    => { _nuxt_link: { name: e.qs_group_info.name, to: { path: e.qs_group_info.link_path }, }, },
          }
        end

        if qs_group_infos.one?
          rows = rows.collect { |e| e.except(:qs_group_key) }
        end

        rows
      end

      private

      def all
        @all ||= yield_self do
          all = Main.all
          if params[:qs_group_only]
            all = all.find_all { |e| e.qs_group_key == params[:qs_group_only] }
          end
          if Rails.env.local?
          else
            all = all.reject { |e| e.qs_group_info.admin_only && !admin_user }
          end
          all
        end
      end

      def qs_group_infos
        @qs_group_infos ||= all.collect(&:qs_group_info).uniq
      end

      def primary_qs_group
        if qs_group_infos.one?
          qs_group_infos.first
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
