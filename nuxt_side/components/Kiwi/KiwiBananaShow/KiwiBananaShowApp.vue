<template lang="pug">
client-only
  .KiwiBananaShowApp
    DebugBox(v-if="development_p")
      p $fetchState.pending: {{$fetchState.pending}}
      p ac_banana_room_connected_count: {{ac_banana_room_connected_count}}

    FetchStateErrorMessage(:fetchState="$fetchState")
    b-loading(:active="$fetchState.pending")

    KiwiBananaShowNavbar(:base="base")
    KiwiBananaShowSidebar(:base="base")

    MainSection.when_mobile_footer_scroll_problem_workaround
      .container.is-fluid
        KiwiBananaShowMain(:base="base" ref="KiwiBananaShowMain" v-if="base.banana")

    KiwiBananaShowDebugPanels(:base="base" v-if="development_p")
</template>

<script>
import { Banana             } from "../models/banana.js"

import { support_parent   } from "./support_parent.js"
import { mod_board         } from "./mod_board.js"
import { mod_support      } from "./mod_support.js"
import { mod_sidebar      } from "./mod_sidebar.js"
import { mod_op           } from "./mod_op.js"
import { mod_table        } from "./mod_table.js"
import { mod_storage      } from "./mod_storage.js"
import { mod_banana_message } from "./mod_banana_message.js"
import { mod_banana_room    } from "./mod_banana_room.js"

import _ from "lodash"

export default {
  name: "KiwiBananaShowApp",
  mixins: [
    support_parent,
    mod_board,
    mod_support,
    mod_sidebar,
    mod_op,
    mod_table,
    mod_storage,
    mod_banana_message,
    mod_banana_room,
  ],

  data() {
    return {
      config: null,
      banana: null,
    }
  },

  // fetchOnServer: false,
  async fetch() {
    // app/controllers/api/kiwi/bananas_controller.rb
    const params = {
      ...this.$route.params,
      ...this.$route.query,
    }
    const e = await this.$axios.$get("/api/kiwi/bananas/show.json", {params})

    this.config = e.config
    this.banana = new Banana(this, e.banana)

    this.clog("process.client", process.client)
    this.clog("process.server", process.server)

    if (process.client) {
      this.banana_room_create()
      this.app_log(`動画 ID:${this.banana.id} ${this.banana.title}`)
    }
  },

  computed: {
    base()    { return this },
    meta()    { return this.banana?.og_meta },

    owner_p() {
      if (this.g_current_user && this.banana) {
        return this.g_current_user.id === this.banana.user.id
      }
    },
  },
}
</script>

<style lang="sass">
@import "../all_support.sass"
.STAGE-development
  .KiwiBananaShowApp
    .container
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .columns
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .column
      border: 1px dashed change_color($success, $alpha: 0.5)

.KiwiBananaShowApp
  .MainSection.section
    +mobile
      padding: 0.75rem
    +tablet
      padding: 1.5rem
</style>
