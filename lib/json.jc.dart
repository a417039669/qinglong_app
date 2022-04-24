// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:qinglong_app/module/config/config_bean.dart';
import 'package:qinglong_app/module/env/env_bean.dart';
import 'package:qinglong_app/module/home/system_bean.dart';
import 'package:qinglong_app/module/login/login_bean.dart';
import 'package:qinglong_app/module/login/user_bean.dart';
import 'package:qinglong_app/module/others/dependencies/dependency_bean.dart';
import 'package:qinglong_app/module/others/login_log/login_log_bean.dart';
import 'package:qinglong_app/module/others/scripts/script_bean.dart';
import 'package:qinglong_app/module/others/task_log/task_log_bean.dart';
import 'package:qinglong_app/module/task/task_bean.dart';


class JsonConversion$Json {

 static M fromJson<M>(dynamic json) {
    if (json is List) {
      return _getListChildType<M>(json);
    } else {
      return _fromJsonSingle<M>(json);
    }
  }

  static M _fromJsonSingle<M>(dynamic json) {

    String type = M.toString();

    if(type == (ConfigBean).toString()){
      return ConfigBean.jsonConversion(json)  as M;
    }
    
    if(type == (EnvBean).toString()){
      return EnvBean.jsonConversion(json)  as M;
    }
    
    if(type == (SystemBean).toString()){
      return SystemBean.jsonConversion(json)  as M;
    }
    
    if(type == (LoginBean).toString()){
      return LoginBean.jsonConversion(json)  as M;
    }
    
    if(type == (UserBean).toString()){
      return UserBean.jsonConversion(json)  as M;
    }
    
    if(type == (DependencyBean).toString()){
      return DependencyBean.jsonConversion(json)  as M;
    }
    
    if(type == (LoginLogBean).toString()){
      return LoginLogBean.jsonConversion(json)  as M;
    }
    
    if(type == (ScriptBean).toString()){
      return ScriptBean.jsonConversion(json)  as M;
    }
    
    if(type == (TaskLogBean).toString()){
      return TaskLogBean.jsonConversion(json)  as M;
    }
    
    if(type == (TaskBean).toString()){
      return TaskBean.jsonConversion(json)  as M;
    }
    
    throw Exception("not found");
  }

  static M _getListChildType<M>(List<dynamic> data) {
      if(<ConfigBean>[] is M){
      return data.map<ConfigBean>((e) => ConfigBean.jsonConversion(e)).toList() as M;
    }
    
    if(<EnvBean>[] is M){
      return data.map<EnvBean>((e) => EnvBean.jsonConversion(e)).toList() as M;
    }
    
    if(<SystemBean>[] is M){
      return data.map<SystemBean>((e) => SystemBean.jsonConversion(e)).toList() as M;
    }
    
    if(<LoginBean>[] is M){
      return data.map<LoginBean>((e) => LoginBean.jsonConversion(e)).toList() as M;
    }
    
    if(<UserBean>[] is M){
      return data.map<UserBean>((e) => UserBean.jsonConversion(e)).toList() as M;
    }
    
    if(<DependencyBean>[] is M){
      return data.map<DependencyBean>((e) => DependencyBean.jsonConversion(e)).toList() as M;
    }
    
    if(<LoginLogBean>[] is M){
      return data.map<LoginLogBean>((e) => LoginLogBean.jsonConversion(e)).toList() as M;
    }
    
    if(<ScriptBean>[] is M){
      return data.map<ScriptBean>((e) => ScriptBean.jsonConversion(e)).toList() as M;
    }
    
    if(<TaskLogBean>[] is M){
      return data.map<TaskLogBean>((e) => TaskLogBean.jsonConversion(e)).toList() as M;
    }
    
    if(<TaskBean>[] is M){
      return data.map<TaskBean>((e) => TaskBean.jsonConversion(e)).toList() as M;
    }
    
    throw Exception("not found");
  }
}
