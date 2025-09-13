import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'features/warehouse/presentation/warehouse_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parse().initialize(
    '4Uhc9Pe3EeSGLpzPXO5bSk4uzeZedgNpjYSp69NR',
    'https://parseapi.back4app.com',
    clientKey: 'oNYKcPvWKmnXSCEN0VMasZclp6Hx5U5nmY1yONuq',
    autoSendSessionId: true,
  );
  runApp(const ProviderScope(child: WarehouseApp()));
}
