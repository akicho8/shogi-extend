<template lang="pug">
.WkbkBookShowAccessBlock
  .columns
    .column
      .hero.is-medium.is-dark
        .hero-body.has-text-centered
          p.title
            | 非公開問題
          p.subtitle.mt-5
            | この問題を見れるのは作成者本人だけです
          b-button.mt-1(@click="sns_login_modal_handle2" type="is-primary" ) ログイン

      WkbkBookShowOxButtons.mt-5(:base="base")
</template>

<script>
import { support_child } from "./support_child.js"

export default {
  name: "WkbkBookShowAccessBlock",
  mixins: [support_child],
}
</script>

<style lang="sass">
@import "../support.sass"
.WkbkBookShowAccessBlock
  +touch
    margin: 1.5rem
  +desktop
    margin: 1.5rem 0
</style>
