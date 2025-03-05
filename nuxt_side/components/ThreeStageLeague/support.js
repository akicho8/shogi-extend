import QueryString from "query-string"

export const support = {
  methods: {
    image_search_url(name) {
      return QueryString.stringifyUrl({
        url: "https://www.google.co.jp/search?tbm=isch",
        query: { q: [name, "将棋"].join(" ") },
      })
    },
  },
}
