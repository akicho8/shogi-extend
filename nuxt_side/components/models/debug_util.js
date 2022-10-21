// |-------|
// | trace |
// |-------|

export const DebugUtil = {
  trace(scope, method) {
    if (process.env.NODE_ENV !== "production") {
      return ""
    }
    let count = "-"
    let side = "SSR"
    if (typeof window !== 'undefined') {
      side = "CSR"
      if (window.$TRACE_COUNT_HASH == null) {
        window.$TRACE_COUNT_HASH = {}
      }
      const key = `${scope}.${method}`
      count = (window.$TRACE_COUNT_HASH[key] ?? 0) + 1
      window.$TRACE_COUNT_HASH[key] = count
    }
    console.debug(`[${side}][${scope}] ${method} (${count}回目)`)
    return ""
  },
}
