# frozen-string-literal: true

#
# 戦法一覧
#
# 一次集計: rails r QuickScript::Swars::TacticListScript.new.cache_write
#
module QuickScript
  module Swars
    class TacticListScript < Base
      class << self
        def mock_setup
          ::Swars::Battle.create!(strike_plan: "原始棒銀")
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
            row["親"] = item.parent ? { _nuxt_link: { name: item.parent.name, to: { path: "/lab/swars/tactic-list", query: { query: item.parent.name, __prefer_url_params__: 1 }, }, }, } : ""
            row["勝率"] = extra_hash.dig(item.key, :win_ratio).try { "%.3f" % self }
            row["頻度"] = extra_hash.dig(item.key, :freq_count) || 0
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

      # |----------------------+-----------+---------------------+------------+------------+----------------------+------------+----------------|
      # | tag_name             | win_count | win_ratio           | draw_count | freq_count | freq_ratio           | lose_count | win_lose_count |
      # |----------------------+-----------+---------------------+------------+------------+----------------------+------------+----------------|
      # | 力戦                 |         7 |  0.5833333333333334 |          0 |         12 |   0.2307692307692308 |          5 |             12 |
      # | 居玉                 |         6 |  0.4615384615384616 |          0 |         13 |                 0.25 |          7 |             13 |
      # | 名人に定跡なし       |         7 |                 1.0 |          0 |          7 |   0.1346153846153846 |          0 |              7 |
      # |----------------------+-----------+---------------------+------------+------------+----------------------+------------+----------------|
      def extra_hash
        @extra_hash ||= TacticAggregator.new.exta_hash
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
            e.class.human_name, # 囲い or 戦法 or 手筋 or 備考
            e.style_info.name,  # 王道
          ]
        end
      end

      concerning :AggregateMethods do
        include CacheMod

        def aggregate_now
          Bioshogi::Analysis::TacticInfo.all_elements.each.with_index.inject({}) do |a, (item, i)|
            a.merge(item.key => battle_ids_of(item, i, ))
          end
        end

        def battle_ids_of(item, i)
          p [Time.current.to_fs(:ymdhms), item, i.fdiv(Bioshogi::Analysis::TacticInfo.all_elements.size)] if false

          ids = []
          ids = finder(item, ids, :win_only_conditon)
          ids = finder(item, ids, :general_conditon)
          ids
        end

        def finder(item, ids, condition_method)
          if ids.size < need_size
            if tag = ActsAsTaggableOn::Tag.find_by(name: item.key)
              taggings = tag.taggings
              # p taggings.where(taggable_type: "Swars::Membership", context: "#{item.tactic_key}_tags").count
              all_block_count = taggings.count.ceildiv(batch_size)
              taggings.in_batches(order: :desc, of: batch_size).each_with_index do |taggings, batch|
                if debug_mode
                  p [Time.current.to_fs(:ymdhms), item, condition_method, batch, all_block_count, batch.fdiv(all_block_count)]
                end
                taggings = taggings.where(taggable_type: "Swars::Membership", context: "#{item.tactic_key}_tags")
                taggable_ids = taggings.pluck(:taggable_id)
                taggable_ids.size <= batch_size or raise "must not happen"

                ########################################

                scope = ::Swars::Membership.where(id: taggable_ids)
                scope = send(condition_method, scope)
                battle_ids = scope.pluck(:battle_id)         # => [57595006, 57487831]
                battle_ids.size <= taggable_ids.size or raise "must not happen"
                if battle_ids.present?
                  p [Time.current.to_fs(:ymdhms), item, ids.size, "+#{battle_ids.size}"] if false
                  ids += battle_ids
                  if ids.size >= need_size
                    ids = ids.take(need_size)
                    p [Time.current.to_fs(:ymdhms), "break"] if false
                    break
                  end
                end
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

        def need_size
          (params[:need_size].presence || 50).to_i
        end

        def batch_size
          1000
        end
      end
    end
  end
end
