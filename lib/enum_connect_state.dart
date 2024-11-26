import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum ConnectState {
  waiting,
  done,
  err,
  none,
}

extension ConnectStateExtension on ConnectState {
  String get name => describeEnum(this);

  bool get isWaiting {
    return this == ConnectState.waiting;
  }

  bool get isDone {
    return this == ConnectState.done;
  }

  bool get isErr {
    return this == ConnectState.err;
  }

  bool get isNone {
    return this == ConnectState.none;
  }
}