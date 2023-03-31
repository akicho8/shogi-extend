export const Xthread = {
  thread_start(block) {
    return setTimeout(block, 0)
  },
  thread_stop(thread_id) {
    if (thread_id) {
      clearTimeout(thread_id)
    }
  },
}
