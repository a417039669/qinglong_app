class Url {
  static const LOGIN = "/api/user/login";
  static const TASKS = "/api/crons";
  static const RUN_TASKS = "/api/crons/run";
  static const STOP_TASKS = "/api/crons/stop";
  static const TASK_DETAIL = "/api/crons/";
  static const ADD_TASK = "/api/crons";
  static const PIN_TASK = "/api/crons/pin";
  static const UNPIN_TASK = "/api/crons/unpin";
  static const ENABLE_TASK = "/api/crons/enable";
  static const DISABLE_TASK = "/api/crons/disable";
  static const FILES = "/api/configs/files";
  static const CONFIG_CONTENT = "/api/configs/";
  static const SAVE_FILE = "/api/configs/save";
  static const ENVS = "/api/envs";
  static const ADD_ENV = "/api/envs";
  static const DEL_ENV = "/api/envs";
  static const DISABLE_ENVS = "/api/disable";
  static const ENABLE_ENVS = "/api/enable";

  static INTIME_LOG(String cronId) {
    return "/api/crons/$cronId/log";
  }
}
