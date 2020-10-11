<template lang="pug">
  b-button.TweetButton.has-text-weight-bold(v-bind="$attrs" v-on="$listeners" size="is-small" type="is-twitter" icon-left="twitter")
    slot
</template>
