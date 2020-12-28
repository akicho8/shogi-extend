import { PaletteInfo } from '@/components/models/PaletteInfo.js'

describe('PaletteInfo', () => {
  it('works', () => {
    expect(PaletteInfo.fetch(0).key).toEqual("link")
  })
})
