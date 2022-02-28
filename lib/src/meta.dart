part of couchify;

// import 'package:securevault/couchbase/expression.dart';

class Meta {
  static final MetaExpression id = MetaExpression("._id");
  static final MetaExpression deleted = MetaExpression("._deleted");
  static final MetaExpression sequence = MetaExpression("._sequence");
  static final MetaExpression expiration = MetaExpression("._expiration");
}
