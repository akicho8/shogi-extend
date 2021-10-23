import MemoryRecord from 'js-memory-record'

export class ApplicationMemoryRecord extends MemoryRecord {
  // 例
  //
  //   data() {
  //     return {
  //       ...FooInfo.null_value_data_hash,
  //     }
  //   },
  //
  static get null_value_data_hash() {
    return this.values.reduce((a, e) => ({...a, [e.key]: null}), {}),
  }
}
