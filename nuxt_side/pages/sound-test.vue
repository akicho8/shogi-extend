<template lang="pug">
.sound-test
  MainNavbar(:spaced="false" wrapper-class="container is-fluid px-0")
    template(slot="brand")
      NavbarItemHome
      b-navbar-item.has-text-weight-bold(tag="nuxt-link" :to="{name: 'sound-test'}") サウンドテスト
  MainSection
    .container.is-fluid
      .buttons
        template(v-for="e of SoundPresetInfo.values")
          b-button(@click="$sound.play(e.key)") {{e.key}}

      .box
        p Howler
        .buttons
          b-button(@click="all_play") すべて再生
          b-button(@click="Howler.stop()") stop()
          b-button(@click="Howler.unload()") unload()

      b Main Volume
      b-numberinput(size="is-small" controls-position="compact" v-model="main_volume" :step="0.1" exponential)

      b-table.mt-4(
        :data="SoundPresetInfo.values"
        :mobile-cards="false"
        @click="row_play"
        narrowed
        )
        b-table-column(v-slot="{row}" field="key" label="KEY" sortable) {{row.key}}
        b-table-column(v-slot="{row}" field="name" label="名前" sortable) {{row.name}}
        b-table-column(v-slot="{row}" field="volume" label="初期" sortable numeric)
          span(:class="{'has-text-weight-bold': row.volume != volumes[row.key]}")
            | {{row.volume}}
        b-table-column(v-slot="{row}" label="音量")
          b-numberinput(size="is-small" controls-position="compact" v-model="volumes[row.key]" :step="0.1" exponential)
</template>

<script>
import { SoundPresetInfo } from "@/components/models/sound_preset_info.js"

export default {
  name: "sound-test",
  data() {
    return {
      volumes: SoundPresetInfo.values.reduce((a, e) => ({...a, [e.key]: e.volume}), {}),
      main_volume: null,
    }
  },
  beforeMount() {
    this.main_volume = Howler.volume()
  },
  watch: {
    main_volume(v) { Howler.volume(v) },
  },
  methods: {
    row_play(row) {
      this.$sound.play(row.key, {volume: this.volumes[row.key]})
    },
    all_play() {
      SoundPresetInfo.values.forEach(e => this.row_play(e))
    },
  },
  computed: {
    SoundPresetInfo() { return SoundPresetInfo },
    Howler() { return Howler      },
  },
}
</script>
