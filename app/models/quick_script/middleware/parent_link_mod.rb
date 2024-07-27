# |----------------------------------------------+--------------------------|
# | Code                                         | 意味                     |
# |----------------------------------------------+--------------------------|
# | self.parent_link = nil                       | 普通に上の階層に上がる   |
# | self.parent_link = { to: "/lab/chore/null" } | nuxt-link の to への引数 |
# | self.parent_link = { go_back: true }         | $router.go(-1)           |
# |----------------------------------------------+--------------------------|

module QuickScript
  module Middleware
    concern :ParentLinkMod do
      prepended do
        class_attribute :parent_link, default: nil # { go_back: true } or { to: "/lab/chore/null" }
      end

      def as_json(*)
        super.merge(parent_link: parent_link)
      end
    end
  end
end
