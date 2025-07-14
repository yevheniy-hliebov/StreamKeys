import 'package:equatable/equatable.dart';

abstract class SecureStorable extends Equatable {
  const SecureStorable();

  Iterable<String> get mapKeys => toMap().keys;
  Map<String, dynamic> toMap();
}
