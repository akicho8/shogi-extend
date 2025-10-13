<template lang="pug">
.SbDebugHowler.column.is-4
  .panel
    .panel-heading
      | 無音化不具合検証用
    a.panel-block(@click="SB.sound_resume_modal_handle") 画面タップ催促表示確認
    a.panel-block(@click="SB.sound_resume_modal_close") 画面タップ催促閉じる
    a.panel-block(@click="SB.sound_bug_start") ガヤ開始
    a.panel-block(@click="SB.sound_bug_stop") ガヤ停止
    a.panel-block(v-if="SB.sb_counter") ガヤ回数 {{SB.sb_counter.counter}}
    a.panel-block(@click="Howler.mute(true)") mute(true)
    a.panel-block(@click="Howler.mute(false)") mute(false)
    a.panel-block(@click="Howler.volume(0)") volume(0)
    a.panel-block(@click="Howler.volume(1.0)") volume(1.0)
    a.panel-block(@click="Howler.stop()") stop()
    a.panel-block(@click="Howler.unload()") unload() 重要
    a.panel-block(@click="Howler.autoUnlock = true") autoUnlock = true
    a.panel-block(@click="Howler.autoSuspend = true") autoSuspend = true
    a.panel-block(@click="Howler.autoSuspend = false") autoSuspend = false
    a.panel-block Howler.volume() → {{Howler.volume()}}
    a.panel-block Howler.usingWebAudio → {{Howler.usingWebAudio}}
    a.panel-block Howler.noAudio → {{Howler.noAudio}}
    a.panel-block Howler.autoUnlock → {{Howler.autoUnlock}}
    a.panel-block Howler.html5PoolSize → {{Howler.html5PoolSize}}
    a.panel-block Howler.autoSuspend → {{Howler.autoSuspend}}
    a.panel-block Howler.ctx → {{$GX.pretty_inspect(Howler.ctx)}}
    a.panel-block Howler.masterGain → {{Howler.masterGain}}
    a.panel-block Howler._howls.length → {{Howler._howls.length}}
</template>

<script>
import { support_child } from "../support_child.js"

export default {
  name: "SbDebugHowler",
  mixins: [support_child],
  computed: {
    Howler() { return window.Howler },
  },
}
</script>

<style lang="sass">
@import "../sass/support.sass"
.SbDebugHowler
  __css_keep__: 0
</style>
