import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pooapp/di/get_it.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();
