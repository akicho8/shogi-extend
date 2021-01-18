import { PaletteInfo } from '@/components/models/palette_info.js'

describe('PaletteInfo', () => {
  it('works', () => {
    expect(PaletteInfo.fetch(0).key).toEqual("link")
  })
})
