<template lang="pug">
tr(v-if="$parent.show_p(dp_key)")
  th(v-html="$parent.key_format(dp_key)")
  td(v-html="$parent.value_format(value)")
</template>

<script>
export default {
  props: [
    "dp_key",
    "value",
  ],
}
</script>
