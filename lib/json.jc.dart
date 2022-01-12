// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:qinglong_app/module/login/login_bean.dart';
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

    if(type == (LoginBean).toString()){
      return LoginBean.jsonConversion(json)  as M;
    }
    
    if(type == (TaskBean).toString()){
      return TaskBean.jsonConversion(json)  as M;
    }
    
    throw Exception("not found");
  }

  static M _getListChildType<M>(List<dynamic> data) {
      if(<LoginBean>[] is M){
      return data.map<LoginBean>((e) => LoginBean.jsonConversion(e)).toList() as M;
    }
    
    if(<TaskBean>[] is M){
      return data.map<TaskBean>((e) => TaskBean.jsonConversion(e)).toList() as M;
    }
    
    throw Exception("not found");
  }
}
