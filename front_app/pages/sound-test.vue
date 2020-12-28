<template lang="pug">
.sound-test
  MainNavbar
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'sound-test'}") サウンドテスト
  MainSection
    .container
      .buttons
        template(v-for="e of SoundPreset.values")
          b-button(@click="sound_play(e.key)") {{e.key}}

      b Main Volume
      b-numberinput(size="is-small" controls-position="compact" v-model="main_volume" :step="0.1" exponential)

      b-table.mt-4(
        :data="SoundPreset.values"
        :mobile-cards="false"
        @click="row_play"
        narrowed
        )
        b-table-column(v-slot="{row}" field="key" label="名前" sortable) {{row.key}}
        b-table-column(v-slot="{row}" field="volume" label="初期" sortable numeric)
          span(:class="{'has-text-weight-bold': row.volume != volumes[row.key]}")
            | {{row.volume}}
        b-table-column(v-slot="{row}" label="音量")
          b-numberinput(size="is-small" controls-position="compact" v-model="volumes[row.key]" :step="0.1" exponential)
</template>

<script>
import { SoundPreset } from "@/components/models/sound_preset.js"
import { Howler } from "howler"

export default {
  name: "sound-test",
  data() {
    return {
      volumes: SoundPreset.values.reduce((a, e) => ({...a, [e.key]: e.volume}), {}),
      main_volume: Howler.volume(),
    }
  },
  watch: {
    main_volume(v) { Howler.volume(v) },
  },
  methods: {
    row_play(row) {
      this.sound_play(row.key, {volume: this.volumes[row.key]})
    },
  },
  computed: {
    SoundPreset() { return SoundPreset },
    Howler()      { return Howler      },
  },
}
</script>
