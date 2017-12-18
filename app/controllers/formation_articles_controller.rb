class FormationArticlesController < ApplicationController
  def index
    rows = Bushido::SkillGroupInfo.flat_map do |group|
      group.model.collect do |e|
        row_build(e)
      end
    end

    out = []
    out << tag.div(:class => "page-header") do
      tag.h2("戦法トリガー辞典", :class => "yumincho")
    end
    out << rows.to_html

    render html: out.join.html_safe, layout: true
  end

  def show
    @record = nil
    Bushido::SkillGroupInfo.each do |e|
      if @record = e.model.lookup(params[:id])
        break
      end
    end

    @all_records = Bushido::SkillGroupInfo.flat_map {|e|e.model.to_a}

    soldiers_hash = @record.board_parser.soldiers.inject({}) { |a, e| a.merge(e[:point] => e) }
    trigger_soldiers_hash = @record.board_parser.trigger_soldiers.inject({}) { |a, e| a.merge(e[:point] => e) }

    # ○ 何もない
    # ● 何かある
    # ☆ 移動元ではない
    group0 = @record.board_parser.other_objects.group_by { |e| e[:something] }
    group1 = group0.transform_values { |v| v.inject({}) {|a, e| a.merge(e[:point] => e) } }

    out = []
    out << tag.div(:class => "page-header") do
      tag.h2(@record, :class => "yumincho text-center")
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
                
                if soldier = trigger_soldiers_hash[point]
                  td_class << "location_#{soldier[:location].key}"
                  td_class << "trigger"
                  str = soldier.any_name
                else
                  if soldier = soldiers_hash[point]
                    td_class << "location_#{soldier[:location].key}"
                    str = soldier.any_name
                  end
                end

                if v = group1["○"]
                  if v[point]
                    td_class << "cell_blank"
                  end
                end

                if v = group1["●"]
                  if v[point]
                    td_class << "something_exist"
                  end
                end

                if v = group1["★"]
                  if v[point]
                    td_class << "any_from_point"
                    # str = icon_tag(:mail_forward)
                  end
                end

                if v = group1["☆"]
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

    out << tag.p do
      info = row_build(@record)
      if v = group0["☆"]
        info["移動元制限"] = v.collect { |e| e[:point].name }.join("、").html_safe + "が移動元ではない"
      end
      info.transform_values(&:presence).compact.to_html
    end

    out << tag.p do
      if index = @all_records.find_index(@record)
        tag.ul(:class => "pager") do
          [
            [-1, [:play, :rotate_180]],
            [+1, [:play]],
          ].collect { |s, icon|
            r = @all_records[(index + s).modulo(@all_records.size)]
            tag.li { link_to(icon_tag(*icon), [:formation_article, id: r.key]) }
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
      row["名前"] = link_to(e.key, [:formation_article, id: e.key])
    end
    row["親"] = e.parent ? link_to(e.parent.name, [:formation_article, id: e.parent.key]) : nil
    row["別親"] = Array(e.other_parents).collect {|e| link_to(e.key, [:formation_article, id: e.key]) }.join(" ").html_safe
    row["種類"] = e.skill_group_info.name

    row["手数制限"] = e.turn_limit ? "#{e.turn_limit}手以内" : nil
    row["手数限定"] = e.turn_eq ? "#{e.turn_eq}手目" : nil

    str = nil
    if e.teban_eq
      str = e.teban_eq == :senteban ? "▲" : "△"
      str = "#{str}限定"
    end
    row["手番"] = str

    row["歩がない"] = e.fuganai ? checked : nil
    row["打時"] = e.stroke_only ? checked : nil
    row["キル時"] = e.kill_only ? checked : nil
    row["開戦前"] = e.kaisenmae ? checked : nil
    row["所持あり"] = Array(e.hold_piece_in).collect(&:name).join(", ")
    row["所持なし"] = Array(e.hold_piece_not_in).collect(&:name).join(", ")
    row["持駒数"] = e.hold_piece_count_eq
    row["持駒一致"] = Array(e.hold_piece_eq).collect(&:name).join(", ")
    row["歩以外不所持"] = e.fu_igai_mottetara_dame ? checked : nil

    if detail?
      row["棋譜検索"] = link_to("将棋ウォーズ棋譜検索", query_search_path(e.key))
    end

    # if e.compare_condition
    #   row["比較"] = e.compare_condition == :include ? "含まれる" : "完全一致"
    # end

    if true
      urls = []
      if e.sankou_url
        urls << e.sankou_url
      end
      if e.respond_to?(:siratama_url) && e.siratama_url
        urls << e.siratama_url
      end
      if detail?
        str = urls.collect { |e|
          link_to(e, e, target: "_blank")
        }.join(tag.br).html_safe
      else
        str = urls.collect.with_index { |e, i|
          link_to("URL#{i.next}", e, target: "_blank")
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
end
