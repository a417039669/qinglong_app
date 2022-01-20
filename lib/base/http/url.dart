import '../../main.dart';
import '../userinfo_viewmodel.dart';

class Url {
  static get login => "/api/user/login";
  static get loginTwo => "/api/user/two-factor/login";
  static const loginByClientId = "/open/auth/token";
  static const user = "/api/user";

  static const updatePassword = "/api/user";

  static get tasks => getIt<UserInfoViewModel>().useSecretLogined ? "/open/crons" : "/api/crons";

  static get runTasks => getIt<UserInfoViewModel>().useSecretLogined ? "/open/crons/run" : "/api/crons/run";

  static get stopTasks => getIt<UserInfoViewModel>().useSecretLogined ? "/open/crons/stop" : "/api/crons/stop";

  static get taskDetail => getIt<UserInfoViewModel>().useSecretLogined ? "/open/crons/" : "/api/crons/";

  static get addTask => getIt<UserInfoViewModel>().useSecretLogined ? "/open/crons" : "/api/crons";

  static get pinTask => getIt<UserInfoViewModel>().useSecretLogined ? "/open/crons/pin" : "/api/crons/pin";

  static get unpinTask => getIt<UserInfoViewModel>().useSecretLogined ? "/open/crons/unpin" : "/api/crons/unpin";

  static get enableTask => getIt<UserInfoViewModel>().useSecretLogined ? "/open/crons/enable" : "/api/crons/enable";

  static get disableTask => getIt<UserInfoViewModel>().useSecretLogined ? "/open/crons/disable" : "/api/crons/disable";

  static get files => getIt<UserInfoViewModel>().useSecretLogined ? "/open/configs/files" : "/api/configs/files";

  static get configContent => getIt<UserInfoViewModel>().useSecretLogined ? "/open/configs/" : "/api/configs/";

  static get saveFile => getIt<UserInfoViewModel>().useSecretLogined ? "/open/configs/save" : "/api/configs/save";

  static get envs => getIt<UserInfoViewModel>().useSecretLogined ? "/open/envs" : "/api/envs";

  static get addEnv => getIt<UserInfoViewModel>().useSecretLogined ? "/open/envs" : "/api/envs";

  static get delEnv => getIt<UserInfoViewModel>().useSecretLogined ? "/open/envs" : "/api/envs";

  static get disableEnvs => getIt<UserInfoViewModel>().useSecretLogined ? "/open/envs/disable" : "/api/envs/disable";

  static get enableEnvs => getIt<UserInfoViewModel>().useSecretLogined ? "/open/envs/enable" : "/api/envs/enable";

  static get loginLog => getIt<UserInfoViewModel>().useSecretLogined ? "/open/user/login-log" : "/api/user/login-log";

  static get taskLog => getIt<UserInfoViewModel>().useSecretLogined ? "/open/logs" : "/api/logs";

  static get taskLogDetail => getIt<UserInfoViewModel>().useSecretLogined ? "/open/logs/" : "/api/logs/";

  static get scripts => getIt<UserInfoViewModel>().useSecretLogined ? "/open/scripts/files" : "/api/scripts/files";
  static get scriptUpdate => getIt<UserInfoViewModel>().useSecretLogined ? "/open/scripts" : "/api/scripts";

  static get scriptDetail => getIt<UserInfoViewModel>().useSecretLogined ? "/open/scripts/" : "/api/scripts/";

  static get dependencies => getIt<UserInfoViewModel>().useSecretLogined ? "/open/dependencies" : "/api/dependencies";

  static get dependencyReinstall => getIt<UserInfoViewModel>().useSecretLogined ? "/open/dependencies/reinstall" : "/api/dependencies/reinstall";




  static intimeLog(String cronId) {
    return getIt<UserInfoViewModel>().useSecretLogined ? "/open/crons/$cronId/log" : "/api/crons/$cronId/log";
  }

  static envMove(String envId) {
    return getIt<UserInfoViewModel>().useSecretLogined ? "/open/envs/$envId/move" : "/api/envs/$envId/move";
  }
}
