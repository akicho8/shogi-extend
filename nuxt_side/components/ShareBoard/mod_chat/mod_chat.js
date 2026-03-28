import { mod_chat_base           } from "./mod_chat_base.js"
import { mod_chat_message_list    } from "./mod_chat_message_list.js"
import { mod_chat_ai_trigger_rule } from "./mod_chat_ai_trigger_rule.js"
import { mod_chat_message_history } from "./mod_chat_message_history.js"

export const mod_chat = {
  mixins: [
    mod_chat_base,
    mod_chat_message_list,
    mod_chat_ai_trigger_rule,
    mod_chat_message_history,
  ],
}
