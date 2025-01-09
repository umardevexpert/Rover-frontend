// TODO(rasto): replace this class with record (something like `typedef ReferenceWrapper<T> = ({T wrapped})?;`) Records
//  are much more lightweight - or if it can be done, use type extension
class ReferenceWrapper<T> {
  final T wrapped;

  const ReferenceWrapper(this.wrapped);
}
