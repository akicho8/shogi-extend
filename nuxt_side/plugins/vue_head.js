import { HeadGenerator } from "@/components/models/head_generator.js"

export const vue_head = {
  head() {
    return (new HeadGenerator(this)).generate()
  },
}
