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

    out = []
    out << tag.div(:class => "page-header") do
      tag.h2(@record, :class => "yumincho text-center")
    end
    out << tag.div(:class => "row") do |;out|
      out = []
      out << tag.div(:class => "col-md-4") do
        row_build(@record).transform_values(&:presence).compact.to_html
      end
      out << tag.div(:class => "col-md-8") do
      end
      out.join.html_safe
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
    
    row["親"] = e.parent ? e.parent.name : nil
    row["別親"] = Array(e.other_parents).collect(&:name).join(", ")
    row["手数制限"] = e.turn_limit
    row["手数限定"] = e.turn_eq

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
