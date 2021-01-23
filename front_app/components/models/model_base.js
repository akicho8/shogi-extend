export class ModelBase {
  get new_record_p() {
    return this.id == null
  }

  get persisted_p() {
    return this.id != null
  }
}
