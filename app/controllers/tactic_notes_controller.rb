class TacticNotesController < ApplicationController
  delegate :soldiers, :trigger_soldiers, :other_objects_hash_ary, :other_objects_hash, :any_exist_soldiers, to: "current_record.board_parser"

  helper_method :current_record

  def index
    params[:mode] ||= "list"

    case params[:mode]
    when "list"
      @rows = Bioshogi::TacticInfo.flat_map do |group|
        group.model.collect { |e| row_build(e) }
      end
    when "tree"
      @tree = Bioshogi::TacticInfo.flat_map do |group|
        group.model.find_all(&:root?).collect { |root|
          root.to_s_tree do |e|
            link_to(e.name, [:tactic_note, id: e.key])
          end
        }.join
      end
    when "fortune"
      @attack_info = Bioshogi::AttackInfo.to_a.sample
      @defense_info = Bioshogi::DefenseInfo.to_a.sample
    end
  end

  def show
    unless current_record
      redirect_to :tactic_notes, alert: "#{params[:id].inspect} は見つかりませんでした"
      return
    end

    # ○ 何もない
    # ● 何かある
    # ☆ 移動元ではない

    if current_record.shape_info
      @board_table = tag.table(:class => "board_inner") do
        Bioshogi::Dimension::Yplace.dimension.times.collect { |y|
          tag.tr {
            Bioshogi::Dimension::Xplace.dimension.times.collect { |x|
              outer_class = []
              inner_class = []

              place = Bioshogi::Place.fetch([x, y])
              str = nil

              # トリガー駒
              if soldier = trigger_soldiers.place_as_key_table[place]
                inner_class << "location_#{soldier.location.key}"
                outer_class << "current"
                str = soldier.any_name
              else
                # トリガーではない駒
                if soldier = soldiers.place_as_key_table[place]
                  inner_class << "location_#{soldier.location.key}"
                  str = soldier.any_name
                end
              end

              # 何もない
              if v = other_objects_hash["○"]
                if v[place]
                  outer_class << "cell_blank"
                end
              end

              # 何かある
              if v = other_objects_hash["●"]
                if v[place]
                  outer_class << "something_exist"
                end
              end

              # 移動元
              if v = other_objects_hash["★"]
                if v[place]
                  outer_class << "origin_place"
                end
              end

              # 移動元ではない
              if v = other_objects_hash["☆"]
                if v[place]
                  outer_class << "not_any_from_place"
                  str = icon_tag(:fab, :times)
                end
              end

              # どれかの駒がある
              if soldier = any_exist_soldiers.find {|e| e.place == place }
                inner_class << "location_#{soldier.location.key}"
                outer_class << "any_exist_soldiers"
                str = soldier.any_name
              end

              tag.td(:class => ["piece_outer", *outer_class]) do
                tag.span(str, :class => ["piece_inner", *inner_class])
              end
            }.join.html_safe
          }
        }.join.html_safe
      end
    end

    row = row_build(current_record)
    if current_record.shape_info
      if v = other_objects_hash_ary["☆"]
        row["移動元制限"] = v.collect { |e| e[:place].name }.join("、").html_safe + "が移動元ではない"
      end
    end
    @detail_hash = row.transform_values(&:presence).compact

    all_records = Bioshogi::TacticInfo.all_elements
    if index = all_records.find_index(current_record)
      @left_right_link = tag.navi(:class => "pagination is-right", role: "navigation", "aria-label": "pagination") do
        [
          [-1, [:play, :rotate_180], "pagination-previous"],
          [+1, [:play],              "pagination-next"],
        ].collect { |s, icon, klass|
          r = all_records[(index + s).modulo(all_records.size)]
          link_to(icon_tag(:fas, *icon), [:tactic_note, id: r.key], :class => klass)
        }.join(" ").html_safe + tag.ul("class": "pagination-list")
      end
    end

  end

  let :sample_kifu_body do
    Rails.cache.fetch("#{__method__}_#{current_record.key}", :expires_in => 1.week) do
      file = Gem.find_files("../experiment/#{current_record.tactic_info.name}/#{current_record.key}.*").first
      parsed_info = Bioshogi::Parser.file_parse(file)
      Bioshogi::KifuFormatInfo.inject({}) do |a, e|
        a.merge(e.key => parsed_info.public_send("to_#{e.key}"))
      end
    end
  end

  def current_record
    @current_record ||= Bioshogi::TacticInfo.flat_lookup(params[:id])
  end

  private

  def sep
    " / "
  end

  def row_build(e)
    row = {}

    if detail?
    else
      row["名前"] = link_to(e.key, [:tactic_note, id: e.key])
    end

    if detail?
      root = e.root
      unless root.children.empty?
        row["系図"] = tag.pre(:class => "tree") do
          root.to_s_tree { |o|
            if o.key == e.key
              o.name
            else
              link_to(o.name, [:tactic_note, id: o.key])
            end
          }.html_safe
        end
      end
    end

    row["手数制限"] = e.turn_limit ? "#{e.turn_limit}手以内" : nil
    row["手数限定"] = e.turn_eq ? "#{e.turn_eq}手目" : nil

    str = nil
    if e.order_key
      str = (e.order_key == :sente) ? "▲" : "△"
      str = "#{str}限定"
    end
    row["手番"] = str

    row["歩がない"] = e.not_have_pawn ? checked : nil
    row["打時"] = e.drop_only ? checked : nil
    row["キル時"] = e.kill_only ? checked : nil
    row["開戦前"] = e.cold_war ? checked : nil
    row["所持あり"] = e.hold_piece_in ? e.hold_piece_in.to_s : nil
    row["所持なし"] = e.hold_piece_not_in ? e.hold_piece_not_in.to_s : nil
    row["持駒が空"] = e.hold_piece_empty ? checked : nil
    row["持駒一致"] = e.hold_piece_eq ? e.hold_piece_eq.to_s : nil
    row["歩以外不所持"] = e.not_have_anything_except_pawn ? checked : nil

    row["種類"] = e.tactic_info.name
    row["別名"] = e.alias_names.join(sep)

    unless detail?
      row["親"] = e.parent ? link_to(e.parent.name, [:tactic_note, id: e.parent.key]) : nil
      row["兄弟"] = e.siblings.collect {|e| link_to(e.key, [:tactic_note, id: e.key]) }.join(sep).html_safe
      row["派生"] = e.children.collect {|e| link_to(e.key, [:tactic_note, id: e.key]) }.join(sep).html_safe
    end

    row["別親"] = Array(e.other_parents).collect {|e| link_to(e.key, [:tactic_note, id: e.key]) }.join(sep).html_safe

    # if e.compare_condition
    #   row["比較"] = e.compare_condition == :include ? "含まれる" : "完全一致"
    # end

    if true
      urls = e.urls.sort

      if detail?
        if false
          urls << h.google_search_url(e.name)
          urls << h.youtube_search_url(e.name)
        end

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
            name = e.truncate(32)
          end
          link_to(name, e, target: "_blank")
        }.join(tag.br).html_safe
        row["参考URL"] = str
      else
        # str = urls.collect.with_index { |e, i|
        #   link_to(("A".ord + i).chr, e, target: "_blank")
        # }.join(" ").html_safe
      end
    end

    row
  end

  def checked
    Fa.icon_tag(:fas, :check)
  end

  def detail?
    params[:action] == "show"
  end
end
