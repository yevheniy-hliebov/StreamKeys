// import 'package:flutter/material.dart';

// void navigateToPage(BuildContext context, {required Widget page}) {
//   Navigator.of(context).push(
//     MaterialPageRoute(
//       builder: (context) => page,
//     ),
//   );
// }

import 'package:flutter/material.dart';

// Глобальний ключ для доступу до Navigator у AppWithObsStatus
final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

void navigateToPage({required Widget page}) {
  appNavigatorKey.currentState?.push(
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}
