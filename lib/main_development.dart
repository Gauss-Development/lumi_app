import 'package:lumi/bootstrap.dart';
import 'package:lumi/core/config/flavor.dart';

Future<void> main() async {
  await bootstrap(flavor: Flavor.development);
}
