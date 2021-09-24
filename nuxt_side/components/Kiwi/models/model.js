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
    return this.to_param == null
  }

  get persisted_p() {
    return this.to_param != null
  }

  get primary_key() {
    return "id"
  }

  get to_param() {
    return this[this.primary_key]
  }
}
