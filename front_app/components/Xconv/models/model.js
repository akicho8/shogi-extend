export class Model {
  constructor(context, attributes) {
    this.context = context
    Object.assign(this, attributes)
  }

  toJSON() {
    const object = {...this}
    delete object.context
    return object
  }

  get new_record_p() {
    return this.id == null
  }

  get persisted_p() {
    return this.id != null
  }
}
