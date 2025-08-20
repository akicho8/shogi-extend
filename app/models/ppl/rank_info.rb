module Ppl
  class RankInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :true_professional,       name: "真のプロ", short_name: "昇段", table_css_class: "has-text-weight-bold has-text-primary-dark", nav_css_class: "has-text-weight-bold is-primary", },
      { key: :substitute_professional, name: "補欠プロ", short_name: "フリ", table_css_class: "has-text-weight-bold has-text-success-dark", nav_css_class: "has-text-weight-bold is-success", },
      { key: :active_member,           name: "現役会員", short_name: "現役", table_css_class: "has-text-weight-bold",                       nav_css_class: "has-text-weight-bold",            },
      { key: :resigned,                name: "退会",     short_name: "",     table_css_class: nil,                                          nav_css_class: nil,                               },
    ]

    prepend AliasMod

    def secondary_key
      [name]
    end
  end
end
