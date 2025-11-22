export class AbstractOperation {
  static create_by_users(...args) {
    const object = new this()
    object.reset_by_users(...args)
    Object.freeze(object)
    return object
  }

  get class_name() {
    return this.constructor.name
  }

  get attributes() {
    return {
      class_name: this.class_name,
    }
  }
}
