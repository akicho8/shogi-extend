# frozen-string-literal: true

#
# 一次集計
# QuickScript::Swars::TacticCrossScript.new.cache_write
# QuickScript::Swars::TacticCrossScript.new.cache_write({}, {batch_limit: 1})
#
# http://localhost:4000/lab/swars/tactic-cross
#
module QuickScript
  module Swars
    class TacticCrossScript < Base
      include SwarsSearchHelperMethods
      include HelperMethods

      self.title        = "将棋ウォーズ戦法人気ランキング (棋力別)"
      self.description  = "棋力別の戦法・囲いなどの頻度・勝率を調べる"
      self.form_method  = :get
      self.button_label = "集計"
      self.debug_mode   = Rails.env.local? && false
      self.json_link = true

      FREQ_RATIO_GTEQ_DEFAULT = 0.0003

      def header_link_items
        super + [
          { name: "全体",   _v_bind: { tag: "nuxt-link", to: { path: "/lab/swars/tactic-stat" }, }, },
          { name: "グラフ", _v_bind: { href: "/lab/swars/tactic-cross.html", target: "_self", }, },
        ]
      end

      def form_parts
        super + [
          {
            :label        => "種類",
            :key          => :scope_key,
            :type         => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => ScopeInfo.form_part_elems,
                :default => scope_key,
              }
            },
          },
          {
            :label        => "順番",
            :key          => :order_key,
            :type         => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => OrderInfo.form_part_elems,
                :default => order_info.key,
              }
            },
          },
          {
            :label        => "勝率ランキング参加条件 頻度N以上",
            :key          => :freq_ratio_gteq,
            :type         => :numeric,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :options      => { min: 0, step: 0.0001 },
                :default      => freq_ratio_gteq,
                :help_message => "初期値: #{FREQ_RATIO_GTEQ_DEFAULT}",
              }
            },
          },
          {
            :label        => "表示",
            :key          => :show_key,
            :type         => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => ShowInfo.form_part_elems,
                :default => show_info.key,
              }
            },
          },
          {
            :label        => "注目",
            :key          => :highlight_plus,
            :type         => :string,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :default => params[:highlight_plus],
                :placeholder => "居飛車 振り飛車 四間飛車 角換わり",
                :help_message => "目立たせる戦法を書く",
              }
            },
          },
          {
            :label        => "除外",
            :key          => :highlight_minus,
            :type         => :string,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :default => params[:highlight_minus],
                :placeholder  => "力戦 居玉",
                :help_message => "邪魔な戦法を書く",
              }
            },
          },
          {
            :label        => "向き",
            :key          => :arrow_key,
            :type         => :radio_button,
            :session_sync => true,
            :dynamic_part => -> {
              {
                :elems   => ArrowInfo.form_part_elems,
                :default => arrow_info.key,
              }
            },
          },
        ]
      end

      def as_general_json
        if false
          current_items_hash    # 段級位をキーにした並び換えおよびフィルタ済みのハッシュ
        else
          aggregate             # R はハッシュの配列になっていた方が扱いやすい
        end
      end

      def call
        simple_table(human_rows, always_table: true)
      end

      def human_rows
        current_items
      end

      def title
        "将棋ウォーズ#{scope_info.name}#{order_info.human_name}ランキング (棋力別)"
      end

      def current_items_hash
        @current_items_hash ||= yield_self do
          items = aggregate
          items = symbolize_values(items)
          items = items.find_all { |e| scope_info.items_set.include?(e[:"名前"]) }
          items = filter_by_freq(items)
          items = items.reject { |e| highlight_minus.include?(e[:"名前"]) }
          items = items.group_by { |e| e[:"棋力"] }
          items = items.transform_values { |e| e.sort_by { |e| [-e.fetch(order_info.order_by), -e.fetch(:"頻度")] } }
        end
      end

      def symbolize_values(items)
        items.collect do |e|
          {
            **e,
            :"棋力" => e[:"棋力"].to_sym,
            :"名前" => e[:"名前"].to_sym,
          }
        end
      end

      def current_items
        @current_items ||= yield_self do
          items = current_items_hash
          top_n = items.values.collect(&:size).max || 0
          items = top_n.times.collect do |i|
            {}.tap do |hv|
              hv["#"] = i.next  # ソートがもげるので文字列にするべからず
              grade_infos.each { |e| hv[head_value(e)] = cell_value(items.dig(e.key, i)) }
            end
          end
        end
      end

      ################################################################################

      def head_value(grade_info)
        if show_info.key == :dot
          zero_with_space + grade_info.short_name # 0幅文字は JavaScript のクソ仕様対策 (ハッシュの順序が変わるのを防ぐ)
        else
          grade_info.name
        end
      end

      def cell_value(attrs)
        if attrs
          instance_exec(attrs, &show_info.value_fn)
        end
      end

      def cell_value_variant(attrs, options = {})
        key = attrs[:"名前"]
        if highlight_plus_set.include?(key)
          link_opts = {}
          link_opts[:class] = "has-text-weight-bold"
          link_opts[:style] = "color: #{palette_from_item_key[key]}"
          item_name_query_search_link(options[:name] || key, key, link_opts)
        else
          if options[:inactive_blank]
            zero_with_space # テーブル列幅が変動するのを防ぐため (一行目で型を判断しているため空だと都合が悪い)
          else
            link_opts = {}
            if options[:inactive_thin]
              link_opts[:class] = "has-text-weight-light has-text-grey-lighter"
            elsif options[:inactive_bold]
              link_opts[:class] = "is_decoration_off has-text-weight-bold"
            else
              link_opts[:class] = "is_decoration_off"
            end
            item_name_query_search_link(options[:name] || key, key, link_opts)
          end
        end
      end

      ################################################################################

      def grade_infos
        @grade_infos ||= ::Swars::GradeInfo.find_all(&:range_10kyu_to_9dan).sort_by(&:priority).public_send(arrow_info.behavior)
      end

      def filter_by_freq(items)
        if order_info.key == :win_rate
          if pivot = freq_ratio_gteq
            items = items.find_all { |e| e[:"頻度"] >= pivot }
          end
        end
        items
      end

      ################################################################################

      def scope_key
        ScopeInfo.lookup_key_or_first(params[:scope_key])
      end

      def scope_info
        ScopeInfo.fetch(scope_key)
      end

      ################################################################################

      def order_key
        OrderInfo.lookup_key_or_first(params[:order_key])
      end

      def order_info
        OrderInfo.fetch(order_key)
      end

      ################################################################################

      def show_key
        ShowInfo.lookup_key_or_first(params[:show_key])
      end

      def show_info
        ShowInfo.fetch(show_key)
      end

      ################################################################################

      def arrow_key
        ArrowInfo.lookup_key_or_first(params[:arrow_key])
      end

      def arrow_info
        ArrowInfo.fetch(arrow_key)
      end

      ################################################################################

      def freq_ratio_gteq
        @freq_ratio_gteq ||= (params[:freq_ratio_gteq].presence || FREQ_RATIO_GTEQ_DEFAULT).to_f
      end

      ################################################################################

      def highlight_plus
        @highlight_plus ||= StringToolkit.split(params[:highlight_plus].to_s).uniq.collect(&:to_sym) # .find_all { |e| scope_info.items_set.include?(e) }
      end

      def highlight_plus_set
        @highlight_plus_set ||= highlight_plus.to_set
      end

      # 未使用
      def __highlight_plus_default
        @__highlight_plus_default ||= current_items_hash["初段"].collect { |e| e[:"名前"] }.take(10)
      end

      ################################################################################

      def highlight_minus
        @highlight_minus ||= StringToolkit.split(params[:highlight_minus].to_s).uniq.collect(&:to_sym) # .find_all { |e| scope_info.items_set.include?(e) }
      end

      def highlight_minus_set
        @highlight_minus_set ||= highlight_minus.to_set
      end

      ################################################################################

      def palette_from_item_key
        @palette_from_item_key ||= highlight_plus.each.with_index.inject({}) { |a, (v, i)| a.merge(v => palette_list[i]) }
      end

      def palette_list
        @palette_list ||= highlight_plus.size.times.collect do |i|
          h = (240.fdiv(360) + 1.0.fdiv(highlight_plus.size) * i).modulo(1.0)
          s = 0.4
          l = 0.5
          Color::HSL.from_fraction(h, s, l).css_hsl
        end
      end

      ################################################################################

      concerning :AggregateMethods do
        include BatchMethods

        def aggregate_now
          main_counts_hash       = {} # { ["九段", "棒銀", "win"] => 個数 } を集める用
          membership_counts_hash = {} # { "九段" => 対局数, } を集める用

          progress_start(main_scope.count.ceildiv(batch_size))
          main_scope.in_batches(of: batch_size).each.with_index do |scope, batch_index|
            progress_next

            if batch_index >= batch_limit
              break
            end

            scope = condition_add(scope)
            main_counts_hash.update(grade_tag_judge_from(scope)) { |_, a, b| a + b }
            membership_counts_hash.update(scope.group(::Swars::Grade.arel_table[:key]).count) { |_, a, b| a + b } # => { "九段" => 1, ... }
          end

          hv = main_counts_hash # => { ["九段", "原始棒銀", "win"] => 1, ... }
          hv = hv.group_by { |(grade_key, tag_name, judge_key), count| [grade_key, tag_name] } # => {["九段", "原始棒銀"] => [[["九段", "原始棒銀", "win"], 1]], }
          hv = hv.transform_values { |a| a.inject(JudgeInfo.zero_default_hash) { |a, ((_, _, judge_key), count)| a.merge(judge_key.to_sym => count) } } # => {["九段", "原始棒銀"] => {win: 1, lose: 0, draw: 0}, }

          items = hv.collect { |(grade_key, tag_name), e| { grade_key: grade_key, tag_name: tag_name, **e } } # 次のコードでハッシュの状態からいきなりまわしてもいいけど、わかりやすいようにいったん配列化しておく

          items = items.collect do |e|
            freq_count = e[:win] + e[:lose] + e[:draw]
            win_ratio  = e[:win].fdiv(freq_count)
            item = Bioshogi::Analysis::TacticInfo.flat_fetch(e[:tag_name])
            membership_count = membership_counts_hash[e[:grade_key]]
            {
              "棋力"      => e[:grade_key],
              "種類"      => item.human_name,
              "スタイル"  => item.style_info.name,
              "名前"      => item.name,
              "勝率"      => win_ratio,
              "頻度"      => freq_count.fdiv(membership_count), # この分母は全体ではなく棋力毎の membership_count とする (重要)
              "出現数"    => freq_count,
              **JudgeInfo.inject({}) { |a, o| a.merge(o.short_name => e[o.key]) },
            }
          end
        end

        def grade_tag_judge_from(s)
          s = s.joins(:taggings => :tag)
          s = s.joins(:judge)
          s = s.group(::Swars::Grade.arel_table[:key])
          s = s.group("tags.name")
          s = s.group("judges.key")
          s.count
        end

        def condition_add(scope)
          scope = scope.joins(:battle => :imode, :grade => nil)
          scope = scope.merge(::Swars::Battle.valid_match_only)
          scope = scope.merge(::Swars::Battle.imode_eq("通常"))
        end
      end
    end
  end
end
