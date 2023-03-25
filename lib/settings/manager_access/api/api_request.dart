import 'dart:convert';

import 'package:firebase_write/settings/manager_access/api/base_url.dart';
import 'package:firebase_write/settings/manager_access/api/db_settings_api.dart';
import 'package:firebase_write/settings/manager_access/current_access/current_access.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiRequest {

  static getAllByClient(table) async {
    try{
      var res = http.post(
        Uri.parse(BaseUrl.get),
        body: { 
          "query": "SELECT * FROM ${DBsettingsApi.dbName}$table WHERE client_id = '${CurrentAccess.client.id}'",
          "db_user": DBsettingsApi.dbUser,
          "db_pass": DBsettingsApi.dbPassword
        }
      );
      return res;
    }catch(e){
      return e;
    }
  }

  static getAll(table) async {
    try{
      var res = http.post(
        Uri.parse(BaseUrl.get),
        body: { 
          "query": "SELECT * FROM ${DBsettingsApi.dbName}$table",
          "db_user": DBsettingsApi.dbUser,
          "db_pass": DBsettingsApi.dbPassword
        }
      );
      return res;
    }catch(e){
      return e;
    }
  }

  static getById(table,id) async {
    try{
      var res = http.post(
        Uri.parse(BaseUrl.get),
        body: { 
          "query": "SELECT * FROM ${DBsettingsApi.dbName}$table WHERE ${table}_id = '$id'",
          "db_user": DBsettingsApi.dbUser,
          "db_pass": DBsettingsApi.dbPassword
        }
      );
      return res;
    }catch(e){
      return e;
    }
  }

  static getCustom(query) async {
    try{
      var res = http.post(
        Uri.parse(BaseUrl.get),
        body: { 
          "query": query,
          "db_user": DBsettingsApi.dbUser,
          "db_pass": DBsettingsApi.dbPassword
        }
      );
      return res;
    }catch(e){
      return e;
    }
  }

  static setData(table,register) async {
    try{
      String keys = "(";
      String values = "(";
      for (String key in register.keys) {
        dynamic value = register[key];
        keys = keys + key + ",";
        values = values + "'" + value + "',";
      }
      keys = keys.substring(0,keys.length-1) + ")";
      values = values.substring(0,values.length-1) + ")";
      
      var res = await http.post(
        Uri.parse(BaseUrl.post),
        body: { 
          "query": "INSERT INTO ${DBsettingsApi.dbName}$table $keys VALUES $values",
          "db_user": DBsettingsApi.dbUser,
          "db_pass": DBsettingsApi.dbPassword
        }
      );

      if(jsonDecode(res.body)['success']==true){
        return [true,jsonDecode(res.body)['id']];
      }

      return [false,'0'];
    }catch(e){
      debugPrint("APIREQUEST SETDATA -> $e");
      return [false,e];
    }
  }

  static delete(table,id) async {
    try{
      var res = await http.post(
        Uri.parse(BaseUrl.post),
        body: { 
          "query": "DELETE FROM ${DBsettingsApi.dbName}$table WHERE ${table}_id = '$id'",
          "db_user": DBsettingsApi.dbUser,
          "db_pass": DBsettingsApi.dbPassword
        }
      );

      if(jsonDecode(res.body)['success']=='true'){
        return true;
      }

      return false;
    }catch(e){
      return e;
    }

  }

  static update(table,register,id) async {
    try{
      String query = "";
      for (String key in register.keys) {
        dynamic value = register[key];
        query = query + key + " = '" + value + "',";
      }
      query = query.substring(0,query.length-1);

      var res = await http.post(
        Uri.parse(BaseUrl.post),
        body: { 
          "query": "UPDATE ${DBsettingsApi.dbName}$table SET $query WHERE ${table}_id = '$id'",
          "db_user": DBsettingsApi.dbUser,
          "db_pass": DBsettingsApi.dbPassword
        }
      );

      if(jsonDecode(res.body)['success'].toString()=="true"){
        return true;
      }

      return false;
    }catch(e){
      return e;
    }
  }

}