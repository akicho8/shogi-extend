# frozen-string-literal: true

#
# 戦法一覧
#
# 一次集計: QuickScript::Swars::TacticListScript.new.cache_write
#
module QuickScript
  module Swars
    class TacticListScript < Base
      class << self
        def mock_setup
          ::Swars::Battle.create!(strike_plan: "原始棒銀") do |e|
            e.memberships.build
            e.memberships.build
          end
        end
      end

      self.title        = "戦法一覧"
      self.description  = "特定の戦法に対応する棋譜に飛べる"
      self.form_method  = :get
      self.button_label = "絞り込み"
      self.debug_mode   = Rails.env.development?

      def form_parts
        super + [
          {
            :label        => "部分一致",
            :key          => :query,
            :type         => :string,
            :dynamic_part => -> {
              {
                :default     => query,
                :placeholder => "ミレ シス",
              }
            },
          },
        ]
      end

      def call
        simple_table(table_rows, always_table: true)
      end

      def table_rows
        filtered_items.collect do |item|
          {}.tap do |row|
            row["名前"] = row_name(item)
            # row["別名"] = item.alias_names.presence.try { self * ", " } || " "
            row["別名"] = { _v_html: "<small>#{item.alias_names * "<br>"}</small>" }
            row["親"] = ""
            if item.parent
              row["親"] = { _nuxt_link: { name: item.parent.name, to: { path: "/lab/swars/tactic-list", query: { query: item.parent.name, __prefer_url_params__: 1 }, }, }, }
            end
            row["スタイル"] = item.style_info.name
            row["種類"] = item.class.human_name
            row[header_blank_column(0)] = { _nuxt_link: { name: "判定条件", to: { path: "/lab/general/encyclopedia", query: { tag: item.name }, }, }, }
            row[header_blank_column(1)] = { _nuxt_link: { name: "棋力帯",   to: { path: "/lab/swars/grade-stat",     query: { tag: item.name }, }, }, }
            row[header_blank_column(2)] = { _nuxt_link: { name: "横断検索", to: { path: "/lab/swars/cross-search",   query: { x_tags: item.name }, }, }, }
          end
        end
      end

      private

      ################################################################################

      def header_blank_column(n)
        "\u200b" * n
      end

      def row_name(item)
        ids = aggregate[item.name.to_sym] || []
        name_with_count = "#{item.name}(#{ids.size})"
        if ids.empty?
          return name_with_count
        end
        query = "id:" + ids.join(",")
        { _nuxt_link: { name: name_with_count, to: { path: "/swars/search", query: { query: query } } } }
      end

      concerning :FilterFunction do
        def query
          params[:query].to_s
        end

        def filtered_items
          @filtered_items ||= yield_self do
            av = searchable_items
            StringToolkit.split(query).each do |q|
              av = av.find_all { |item, str| str.include?(q) }
            end
            av.collect { |item, str| item }.sort_by(&:key)
          end
        end

        # [
        #   [<セメント囲い>, "セメント囲い|カタツムリ"],
        #   [<ヒラメ戦法>,   "ヒラメ戦法|平目"],
        # ]
        def searchable_items
          @searchable_items ||= yield_self do
            items = Bioshogi::Analysis::TacticInfo.all_elements
            items.collect { |e| [e, [e.name, *searchable_strings(e)].join("|")] }
          end
        end

        def searchable_strings(e)
          [
            e.name,             # セメント囲い
            *e.alias_names,     # カタツムリ
            e.class.human_name, # 囲い
            e.style_info.name,  # 王道
          ]
        end
      end

      concerning :AggregateMethods do
        include CacheMod

        def aggregate_now
          Bioshogi::Analysis::TacticInfo.all_elements.inject({}) do |a, item|
            a.merge(item.key => battle_ids_of(item))
          end
        end

        def battle_ids_of(item)
          ids = []
          ids = finder(item, ids, :win_only_conditon)
          ids = finder(item, ids, :general_conditon)
          ids
        end

        def finder(item, ids, condition_method)
          if ids.size < need_size
            main_scope.in_batches(of: batch_size).each_with_index do |scope, batch|
              if debug_mode
                p [item.key, ids.size, batch, all_block_count, batch.fdiv(all_block_count)]
              end
              scope = send(condition_method, scope)
              ids += scope.tagged_with(item.key).pluck(:battle_id)
              if ids.size >= need_size
                ids = ids.take(need_size)
                break
              end
            end
          end
          ids
        end

        # その戦法で勝った棋譜がほしいので最初の条件には「勝ち」を入れる
        def win_only_conditon(scope)
          scope = scope.joins(:judge).where(Judge.arel_table[:key].eq(:win))
          scope = general_conditon(scope)
        end

        # それで見つからない場合もあるので次は条件を緩くする
        def general_conditon(scope)
          scope = scope.joins(battle: :xmode).where(::Swars::Xmode.arel_table[:key].eq(:"野良"))
          scope = scope.joins(:grade).order(::Swars::Grade.arel_table[:priority])
        end

        def main_scope
          params[:scope] || ::Swars::Membership.all
        end

        def all_block_count
          @all_block_count ||= main_scope.count.ceildiv(batch_size)
        end

        def need_size
          (params[:need_size].presence || 1).to_i
        end

        def batch_size
          1000
        end
      end
    end
  end
end
