import { mod_quiz_host   } from "./mod_quiz_host.js"
import { mod_quiz_client } from "./mod_quiz_client.js"

export const mod_fes = {
  mixins: [
    mod_quiz_host,
    mod_quiz_client,
  ],
}
