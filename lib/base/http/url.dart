class Url {
  static const LOGIN = "/api/user/login";
  static const TASKS = "/api/crons";
  static const RUN_TASKS = "/api/crons/run";
  static const STOP_TASKS = "/api/crons/stop";
  static const TASK_DETAIL = "/api/crons/";
  static const ADD_TASK = "/api/crons";

  static INTIME_LOG(String cronId) {
    return "/api/crons/$cronId/log";
  }
}
