import { mod_misuse_detector } from "./mod_misuse_detector.js"
import { mod_core } from "./mod_core.js"

export const mod_move_sync = {
  mixins: [
    mod_core,
    mod_misuse_detector,
  ],
}
