import 'core/flavors/flavor.dart';
import 'core/flavors/flavors_config.dart';
import 'main.dart';

void main() async {
  FlavorsConfig.init(Flavor.mock);
  await initApp();
}
