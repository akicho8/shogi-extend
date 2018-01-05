class TacticArticlesController < ApplicationController
  delegate :soldiers_hash, :trigger_soldiers_hash, :other_objects_hash_ary, :other_objects_hash, :to => "current_record.board_parser"

  def index
    params[:mode] ||= "list"

    case params[:mode]
    when "list"
      @rows = Bushido::TacticInfo.flat_map do |group|
        group.model.collect { |e| row_build(e) }
      end
    when "tree"
      @tree = Bushido::TacticInfo.flat_map do |group|
        group.model.find_all(&:root?).collect { |root|
          root.to_s_tree do |e|
            link_to(e.name, [:tactic_article, id: e.key])
          end
        }.join
      end
    when "fortune"
      @attack_info = Bushido::AttackInfo.to_a.sample
      @defense_info = Bushido::DefenseInfo.to_a.sample
    end
  end

  def show
    # ○ 何もない
    # ● 何かある
    # ☆ 移動元ではない

    out = []
    out << tag.div(:class => "page-header") do
      tag.h2(current_record, :class => "yumincho text-center")
    end
    out << tag.div(:class => "row") do |;out|
      out = []
      out << tag.div(:class => "col-md-12") do |;out|
        out = []
        out << tag.table(:class => "kakoi_table") do
          Bushido::Position::Vpos.board_size.times.collect { |y|
            tag.tr {
              Bushido::Position::Hpos.board_size.times.collect { |x|
                td_class = []

                point = Bushido::Point.fetch([x, y])
                str = nil

                # トリガー駒
                if soldier = trigger_soldiers_hash[point]
                  td_class << "location_#{soldier[:location].key}"
                  td_class << "trigger"
                  str = soldier.any_name
                else
                  # トリガーではない駒
                  if soldier = soldiers_hash[point]
                    td_class << "location_#{soldier[:location].key}"
                    str = soldier.any_name
                  end
                end

                # 何もない
                if v = other_objects_hash["○"]
                  if v[point]
                    td_class << "cell_blank"
                  end
                end

                # 何かある
                if v = other_objects_hash["●"]
                  if v[point]
                    td_class << "something_exist"
                  end
                end

                # 移動元
                if v = other_objects_hash["★"]
                  if v[point]
                    td_class << "any_from_point"
                  end
                end

                # 移動元ではない
                if v = other_objects_hash["☆"]
                  if v[point]
                    td_class << "not_any_from_point"
                    str = icon_tag(:times)
                  end
                end

                tag.td(str, :class => td_class)
              }.join.html_safe
            }
          }.join.html_safe
        end

        out.join.html_safe
      end
      out.join.html_safe
    end

    out << tag.br

    out << tag.p(:class => "text-center") do
      [
        link_to("2ch棋譜検索",          [:resource_ns1, :general_search, query: current_record.key], :class => "btn btn-link"),
        link_to("将棋ウォーズ棋譜検索", [:resource_ns1, :swars_search, query: current_record.key],   :class => "btn btn-link"),
      ].join(" ").html_safe
    end

    out << tag.p do
      info = row_build(current_record)
      if v = other_objects_hash_ary["☆"]
        info["移動元制限"] = v.collect { |e| e[:point].name }.join("、").html_safe + "が移動元ではない"
      end
      info.transform_values(&:presence).compact.to_html
    end

    # root = current_record.root
    # unless root.children.empty?
    #   out << tag.pre(:class => "tree") do
    #     root.to_s_tree { |e|
    #       if current_record.key == e.key
    #         e.name
    #       else
    #         link_to(e.name, [:tactic_article, id: e.key])
    #       end
    #     }.html_safe
    #   end
    # end

    out << tag.p do
      all_records = Bushido::TacticInfo.flat_map {|e|e.model.to_a}
      if index = all_records.find_index(current_record)
        tag.ul(:class => "pager") do
          [
            [-1, [:play, :rotate_180]],
            [+1, [:play]],
          ].collect { |s, icon|
            r = all_records[(index + s).modulo(all_records.size)]
            tag.li { link_to(icon_tag(*icon), [:tactic_article, id: r.key]) }
          }.join(" ").html_safe
        end
      end
    end

    render html: out.join.html_safe, layout: true
  end

  private

  def row_build(e)
    row = {}

    if detail?
    else
      row["名前"] = link_to(e.key, [:tactic_article, id: e.key])
    end
    row["種類"] = e.tactic_info.name

    if detail?
      root = e.root
      unless root.children.empty?
        row["系図"] = tag.pre(:class => "tree") do
          root.to_s_tree { |o|
            if o.key == e.key
              o.name
            else
              link_to(o.name, [:tactic_article, id: o.key])
            end
          }.html_safe
        end
      end
    else
      row["親"] = e.parent ? link_to(e.parent.name, [:tactic_article, id: e.parent.key]) : nil
      row["兄弟"] = e.siblings.collect {|e| link_to(e.key, [:tactic_article, id: e.key]) }.join(" ").html_safe
      row["派生"] = e.children.collect {|e| link_to(e.key, [:tactic_article, id: e.key]) }.join(" ").html_safe
    end
    row["別親"] = Array(e.other_parents).collect {|e| link_to(e.key, [:tactic_article, id: e.key]) }.join(" ").html_safe

    row["手数制限"] = e.turn_limit ? "#{e.turn_limit}手以内" : nil
    row["手数限定"] = e.turn_eq ? "#{e.turn_eq}手目" : nil

    str = nil
    if e.order_key
      str = (e.order_key == :sente) ? "▲" : "△"
      str = "#{str}限定"
    end
    row["手番"] = str

    row["歩がない"] = e.not_have_pawn ? checked : nil
    row["打時"] = e.stroke_only ? checked : nil
    row["キル時"] = e.kill_only ? checked : nil
    row["開戦前"] = e.cold_war ? checked : nil
    row["所持あり"] = Array(e.hold_piece_in).collect(&:name).join(", ")
    row["所持なし"] = Array(e.hold_piece_not_in).collect(&:name).join(", ")
    row["持駒数"] = e.hold_piece_count_eq
    row["持駒一致"] = Array(e.hold_piece_eq).collect(&:name).join(", ")
    row["歩以外不所持"] = e.not_have_anything_except_pawn ? checked : nil

    # if e.compare_condition
    #   row["比較"] = e.compare_condition == :include ? "含まれる" : "完全一致"
    # end

    if true
      urls = e.urls.sort

      if detail?
        urls << h.google_search_url(e.name)
        urls << h.youtube_search_url(e.name)

        str = urls.collect { |e|
          case e
          when /mijinko83/
            name = "続・裏小屋日記 完結編"
          when /wikipedia/
            name = "Wikipedia"
          when /siratama/
            name = "しらたまの甘味所"
          when /google/
            name = "Google 検索"
          when /youtube.*watch/
            name = "動画"
          when /youtube/
            name = "Youtube 検索"
          when /mudasure/
            name = "ムダスレ無き改革"
          else
            name = e
          end
          link_to(name, e, target: "_blank")
        }.join(tag.br).html_safe
      else
        str = urls.collect.with_index { |e, i|
          link_to(("A".ord + i).chr, e, target: "_blank")
        }.join(" ").html_safe
      end
      row["参考URL"] = str
    end

    row
  end

  def checked
    Fa.icon_tag(:check)
  end

  def detail?
    params[:action] == "show"
  end

  def current_record
    @current_record ||= -> {
      v = nil
      Bushido::TacticInfo.each do |e|
        if v = e.model.lookup(params[:id])
          break
        end
      end
      v
    }.call
  end
end
