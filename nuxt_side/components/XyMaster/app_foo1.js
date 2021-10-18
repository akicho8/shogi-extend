import { Foo1Info } from "./models/foo1_info.js"

export const app_foo1 = {
  data() {
    return {
      foo1_key: null,
    }
  },
  methods: {
  },
  computed: {
    Foo1Info()  { return Foo1Info                                         },
    foo1_info() { return Foo1Info.fetch(this.foo1_key)                    },
  },
}
