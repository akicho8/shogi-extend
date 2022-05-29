<template lang="pug">
.columns.is-vcentered.is-multiline.xform_block
  .column
    nav.level.is-mobile
      .level-item.has-text-centered
        div
          .heading 実行時間(秒)
          .title {{number_floor(xi.processed_sec, 3)}}
</template>

<script>
export default {
  name: "SwarsHistogramProcessedSec",
  props: {
    xi: { type: Object, required: true },
  },
}
</script>
