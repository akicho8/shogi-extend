export const support = {
  methods: {
    image_search_url(name) {
      const url = new URL("https://www.google.co.jp/search?tbm=isch")
      url.searchParams.set("q", [name, "将棋"].join(" "))
      return url.toString()
    },
  },
}
