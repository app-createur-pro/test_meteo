import 'flavor.dart';

class FlavorsConfig {
  final Flavor flavor;
  static late FlavorsConfig instance;

  FlavorsConfig._internal(this.flavor);

  static void init(Flavor flavor) {
    instance = FlavorsConfig._internal(flavor);
  }

  static bool get isMock => instance.flavor == Flavor.mock;
}
