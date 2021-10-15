<template lang="pug">
client-only
  .GalleryBananaShowApp
    DebugBox(v-if="development_p")
      p $fetchState.pending: {{$fetchState.pending}}
      p ac_banana_room_connected_count: {{ac_banana_room_connected_count}}

    FetchStateErrorMessage(:fetchState="$fetchState")
    b-loading(:active="$fetchState.pending")

    GalleryBananaShowNavbar(:base="base")
    GalleryBananaShowSidebar(:base="base")

    MainSection.when_mobile_footer_scroll_problem_workaround
      .container.is-fluid
        GalleryBananaShowMain(:base="base" ref="GalleryBananaShowMain" v-if="base.banana")

    GalleryBananaShowDebugPanels(:base="base" v-if="development_p")
</template>

<script>
import { Banana             } from "../models/banana.js"

import { support_parent   } from "./support_parent.js"
import { app_board         } from "./app_board.js"
import { app_support      } from "./app_support.js"
import { app_sidebar      } from "./app_sidebar.js"
import { app_op           } from "./app_op.js"
import { app_table        } from "./app_table.js"
import { app_storage      } from "./app_storage.js"
import { app_banana_message } from "./app_banana_message.js"
import { app_banana_room    } from "./app_banana_room.js"

import _ from "lodash"

export default {
  name: "GalleryBananaShowApp",
  mixins: [
    support_parent,
    app_board,
    app_support,
    app_sidebar,
    app_op,
    app_table,
    app_storage,
    app_banana_message,
    app_banana_room,
  ],

  data() {
    return {
      config: null,
      banana: null,
    }
  },

  // fetchOnServer: false,
  async fetch() {
    // app/controllers/api/gallery/bananas_controller.rb
    const params = {
      ...this.$route.params,
      ...this.$route.query,
    }
    const e = await this.$axios.$get("/api/gallery/bananas/show.json", {params})

    this.config = e.config
    this.banana = new Banana(this, e.banana)

    this.clog("process.client", process.client)
    this.clog("process.server", process.server)

    if (process.client) {
      this.banana_room_create()
      this.ga_click(`動画 ID:${this.banana.id} ${this.banana.title}`)
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
  .GalleryBananaShowApp
    .container
      border: 1px dashed change_color($danger, $alpha: 0.5)
    .columns
      border: 1px dashed change_color($primary, $alpha: 0.5)
    .column
      border: 1px dashed change_color($success, $alpha: 0.5)

.GalleryBananaShowApp
  .MainSection.section
    +mobile
      padding: 0.75rem
    +tablet
      padding: 1.5rem
</style>
