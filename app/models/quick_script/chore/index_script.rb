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
            :dynamic_part => -> {
              {
                :default => params[:query].to_s,
              }
            },
          },
        ]
      end

      def call
        if all.empty?
          return "ここにはなんもありません"
        end

        # USER_AGENT によって切り替えるのはカオスになるのでやめる
        # 表示に拘ると QuickScript を作った意味がなくなる
        if params[:user_agent_key] == "mobile" && false
          # values = rows.collect { |e|
          #   { _component: "QuickScriptViewValueAsH", _v_bind: { value: [e["項目"], e["内容"]] }, style: {"gap" => "0.5rem"} }
          # }
          values = rows.collect { |e| e["項目"] }
          return { _component: "QuickScriptViewValueAsV", _v_bind: { value: values }, style: {"gap" => "0.5rem"} }
        end

        rows
      end

      def rows
        @rows ||= yield_self do
          rows = all_sort(all).collect do |e|
            row = {
              "項目"     => { _nuxt_link: { name: e.title_for_index, to: { path: e.qs_path }, }, },
              "内容"     => { :_v_text => e.description, :tag => :span, :class => "is_line_break_on" },
              "グループ" => { _nuxt_link: { name: e.qs_group_info.name, to: { path: e.qs_group_info.qs_path }, }, },
            }
            if admin_user || Rails.env.local?
              row["API"] = tag.a(e.qs_key, href: e.qs_api_url, target: "_blank")
            end
            row
          end

          # rows = rows.collect { |e| e.except("内容") }

          if qs_group_infos.one?
            rows = rows.collect { |e| e.except("グループ") }
          end
          rows
        end
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

      def parent_link
        if params[:qs_group_only]
          { force_link_to: "/lab" }
        else
          { force_link_to: "/lab/chore" }
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
