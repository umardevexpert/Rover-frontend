// here only include types that are generally useful
// types specific for particular class and its clients should be defined in that class

typedef VoidCallback = void Function();
// TODO(rasto): consider reordering generic parameters of all Projectors so that TOut is always the first. This corresponds to
// the function syntax and thus is more expected than having it on last position. Reordering would have to be done
// everywhere.
typedef Projector<TIn, TOut> = TOut Function(TIn);
typedef Projector2<TIn1, TIn2, TOut> = TOut Function(TIn1, TIn2);
typedef Projector3<TIn1, TIn2, TIn3, TOut> = TOut Function(TIn1, TIn2, TIn3);
typedef Projector4<TIn1, TIn2, TIn3, TIn4, TOut> = TOut Function(TIn1, TIn2, TIn3, TIn4);
typedef Projector5<TIn1, TIn2, TIn3, TIn4, TIn5, TOut> = TOut Function(TIn1, TIn2, TIn3, TIn4, TIn5);

typedef StringBuilder<T> = Projector<T, String>;
typedef Predicate<T> = Projector<T, bool>; // consider renaming Predicate to Condition

/// Alternative to ValueChanged<T> for projects that do not use Flutter
typedef Consumer<T> = void Function(T value);

typedef JsonDoc = Map<String, dynamic>;
typedef DocDeserializer<T> = Projector<JsonDoc, T>;
