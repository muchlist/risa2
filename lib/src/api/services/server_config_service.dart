import 'dart:io';

import 'package:dio/dio.dart';

import '../filter_models/check_filter.dart';
import '../http_client.dart';
import '../json_models/request/server_config_req.dart';
import '../json_models/response/message_resp.dart';
import '../json_models/response/server_config_list_resp.dart';
import '../json_models/response/server_config_resp.dart';
import '../json_parsers/json_parsers.dart';
import '../json_parsers/server_config_parser.dart';

class ServerConfigService {
  const ServerConfigService();

  Future<MessageResponse> createServerConfig(ServerConfigRequest payload) {
    return RequestREST(endpoint: "/config", data: payload.toJson())
        .executePost<MessageResponse>(const MessageParser());
  }

  Future<ServerConfigDetailResponse> uploadImage(String id, File file) async {
    // var fileName = file.path.split('/').last;
    return RequestREST(endpoint: "/config-image/$id", data: <String, dynamic>{
      "image": await MultipartFile.fromFile(file.path)
    }).executeUpload(const ServerConfigParser());
  }

  Future<MessageResponse> uploadImageForPath(File file) async {
    return RequestREST(endpoint: "/config-image-force", data: <String, dynamic>{
      "image": await MultipartFile.fromFile(file.path)
    }).executeUpload<MessageResponse>(const MessageParser());
  }

  Future<ServerConfigDetailResponse> getServerConfig(String id) {
    return RequestREST(endpoint: "/config/$id")
        .executeGet<ServerConfigDetailResponse>(const ServerConfigParser());
  }

  Future<MessageResponse> deleteServerConfig(String id) {
    return RequestREST(endpoint: "/config/$id")
        .executeDelete<MessageResponse>(const MessageParser());
  }

  Future<ServerConfigListResponse> findServerConfig(FilterCheck f) {
    String query = "";
    if (f.branch != null) {
      query = query + "branch=${f.branch}&";
    }
    if (f.start != null) {
      query = query + "start=${f.start}&";
    }
    if (f.end != null) {
      query = query + "end=${f.end}&";
    }
    return RequestREST(endpoint: "/config?$query")
        .executeGet<ServerConfigListResponse>(const ServerConfigListParser());
  }
}
