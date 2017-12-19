class RandomArticlesController < ApplicationController
  def show
    attack_info = Bushido::AttackInfo.to_a.sample
    defense_info = Bushido::DefenseInfo.to_a.sample

    render html: tag.div(:class => "text-center random_articles text-nowrap") {
      tag.div(:class => "page-header") {
        tag.h2("今日の戦法占い", :class => "yumincho")
      } + tag.div {
        tag.p {
          link_to(attack_info.name, [:formation_article, id: attack_info.key], :class => "yumincho")
        } + tag.p {
          link_to(defense_info.name, [:formation_article, id: defense_info.key], :class => "yumincho")
        }
      }
    }, layout: true
  end
end
