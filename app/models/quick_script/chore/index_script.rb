module QuickScript
  module Chore
    class IndexScript < Base
      self.title = "Index"
      self.description = "一覧を表示する"
      self.form_method = :get
      self.button_label = "検索"

      def form_parts
        super + [
          {
            :key     => :query,
            :type    => :string,
            :default => params[:query].to_s,
          },
        ]
      end

      def call
        if all.empty?
          return "ここにはなんもありません"
        end

        rows = all_sort(all).collect do |e|
          row = {
            "名前"     => { _nuxt_link: { name: e.title_for_index, to: { path: e.qs_path }, }, },
            "内容"     => { :_v_text => e.description, :tag => :span, :class => "is_line_break_on" },
            "グループ" => { _nuxt_link: { name: e.qs_group_info.name, to: { path: e.qs_group_info.qs_path }, }, },
          }
          if admin_user || Rails.env.local?
            row["API"] = tag.a(e.qs_key, href: e.qs_api_url, target: "_blank")
          end
          row
        end

        if qs_group_infos.one?
          rows = rows.collect { |e| e.except("グループ") }
        end

        rows
      end

      def all
        @all ||= yield_self do
          all = Dispatcher.all
          if params[:qs_group_only]
            all = all.find_all { |e| e.qs_group_key == params[:qs_group_only] }
          end
          if Rails.env.local?
          else
            all = all.reject { |e| e.qs_group_info.admin_only && !admin_user }
          end

          if show_all
          else
            all = all.reject { |e| e.qs_invisible }

            if current_queries.present?
              current_queries.each do |query|
                all = all.find_all do |e|
                  [
                    e.title,
                    e.description,
                    e.name,
                  ].join("/").downcase.include?(query.downcase)
                end
              end
            end
          end

          all
        end
      end

      def title
        if primary_qs_group
          primary_qs_group.name
        else
          super
        end
      end

      private

      def all_sort(all)
        all.sort_by do |e|
          [e.qs_group_info, e.ordered_index, e.title]
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

      def current_queries
        params[:query].to_s.scan(/\S+/)
      end

      def show_all
        params[:query].to_s.strip == "*"
      end
    end
  end
end
