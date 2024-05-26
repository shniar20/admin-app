import "package:employee/store/admin_provider.dart";
import "package:provider/provider.dart";
import "package:provider/single_child_widget.dart";

final List<SingleChildWidget> appProviders = [
  ChangeNotifierProvider(create: (_) => AdminProvider()),
];
