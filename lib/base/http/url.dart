class Url {
  static const login = "/api/user/login";
  static const tasks = "/api/crons";
  static const runTasks = "/api/crons/run";
  static const stopTasks = "/api/crons/stop";
  static const taskDetail = "/api/crons/";
  static const addTask = "/api/crons";
  static const pinTask = "/api/crons/pin";
  static const unpinTask = "/api/crons/unpin";
  static const enableTask = "/api/crons/enable";
  static const disableTask = "/api/crons/disable";
  static const files = "/api/configs/files";
  static const configContent = "/api/configs/";
  static const saveFile = "/api/configs/save";
  static const envs = "/api/envs";
  static const addEnv = "/api/envs";
  static const delEnv = "/api/envs";
  static const disableEnvs = "/api/envs/disable";
  static const enableEnvs = "/api/envs/enable";
  static const loginLog = "/api/user/login-log";
  static const taskLog = "/api/logs";
  static const taskLogDetail = "/api/logs/code/";
  static const scripts = "/api/scripts/files";
  static const scriptDetail = "/api/scripts/";
  static const dependencies = "/api/dependencies";
  static const dependencyReinstall = "/api/dependencies/reinstall";

  static intimeLog(String cronId) {
    return "/api/crons/$cronId/log";
  }

  static envMove(String envId) {
    return "/api/envs/$envId/move";
  }
}
