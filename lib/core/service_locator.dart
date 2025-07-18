import 'package:flutter_travel_ai_app/core/networks/network_config.dart';
import 'package:flutter_travel_ai_app/core/repositories/remote/remote_repo.dart';
import 'package:flutter_travel_ai_app/core/repositories/remote/remote_repo_interface.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

Future<void> setupServiceLocator() async {
  locator.registerSingleton<NetworkProvider>(NetworkProvider());

  locator.registerSingleton<RemoteRepoInterface>(
    RemoteRepo(networkProvider: locator<NetworkProvider>()),
  );
}
