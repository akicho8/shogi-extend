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
            :scategory   => { _nuxt_link: { name: e.scategory_info.name, to: { path: e.scategory_info.link_path }, }, },
          }
        end

        if scategory_infos.one?
          rows = rows.collect { |e| e.except(:scategory) }
        end

        rows
      end

      private

      def all
        @all ||= yield_self do
          all = Main.all
          if params[:scategory_only]
            all = all.find_all { |e| e.scategory == params[:scategory_only] }
          end
          if Rails.env.local?
          else
            all = all.reject { |e| e.scategory_info.admin_required && !admin_user }
          end
          all
        end
      end

      def scategory_infos
        @scategory_infos ||= all.collect(&:scategory_info).uniq
      end

      def primary_scategory
        if scategory_infos.one?
          scategory_infos.first
        end
      end

      def title
        if primary_scategory
          primary_scategory.name
        else
          super
        end
      end
    end
  end
end
