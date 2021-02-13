export class ModelBase {
  get new_record_p() {
    return this.key == null
  }

  get persisted_p() {
    return this.key != null
  }
}
