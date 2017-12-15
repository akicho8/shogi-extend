class RandomArticlesController < ApplicationController
  def show
    attack_info = Bushido::AttackInfo.to_a.sample
    defense_info = Bushido::DefenseInfo.to_a.sample

    out = []
    out << tag.div(:class => "text-center random_articles text-nowrap") do |;out|
      out = []
      out << tag.div(:class => "page-header") do
        tag.h2("今日の戦法占い", :class => "yumincho")
      end
      out << tag.p do
        link_to(attack_info.name, [:formation_article, id: attack_info.key], :class => "yumincho")
      end
      out << tag.p do
        link_to(defense_info.name, [:formation_article, id: defense_info.key], :class => "yumincho")
      end
      out.join.html_safe
    end

    render html: out.join.html_safe, layout: true
  end
end
