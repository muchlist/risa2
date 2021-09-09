import 'dart:collection';
import 'dart:io';

import 'package:flutter/cupertino.dart';

import '../api/filter_models/check_filter.dart';
import '../api/json_models/request/server_config_req.dart';
import '../api/json_models/response/message_resp.dart';
import '../api/json_models/response/server_config_list_resp.dart';
import '../api/json_models/response/server_config_resp.dart';
import '../api/services/server_config_service.dart';
import '../globals.dart';
import '../utils/enums.dart';
import '../utils/image_compress.dart';

class ServerConfigProvider extends ChangeNotifier {
  ServerConfigProvider(this._serverConfigService);
  final ServerConfigService _serverConfigService;

  // =======================================================
  // List ServerConfig

  // * state
  ViewState _state = ViewState.idle;
  ViewState get state => _state;
  void setState(ViewState viewState) {
    _state = viewState;
    notifyListeners();
  }

  // serverConfig list cache
  List<ServerConfigResponse> _serverConfigList = <ServerConfigResponse>[];
  List<ServerConfigResponse> get serverConfigList {
    return UnmodifiableListView<ServerConfigResponse>(_serverConfigList);
  }

  // *memasang filter pada pencarian serverConfig
  FilterCheck _filterServerConfig = FilterCheck(
    branch: App.getBranch(),
  );
  void setFilter(FilterCheck filter) {
    _filterServerConfig = filter;
  }

  // * Mendapatkan serverConfig
  Future<void> findServerConfig({bool loading = true}) async {
    if (loading) {
      setState(ViewState.busy);
    }

    String error = "";
    try {
      final ServerConfigListResponse response =
          await _serverConfigService.findServerConfig(_filterServerConfig);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _serverConfigList = response.data;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);

    if (error.isNotEmpty) {
      return Future<void>.error(error);
    }
  }

// ========================================================
  // detail serverConfig

  // * detail state
  ViewState _detailState = ViewState.idle;
  ViewState get detailState => _detailState;
  void setDetailState(ViewState viewState) {
    _detailState = viewState;
    notifyListeners();
  }

  String _serverConfigIDSaved = "";
  void setServerConfigID(String serverConfigID) {
    _serverConfigIDSaved = serverConfigID;
  }

  String getServerConfigId() => _serverConfigIDSaved;

  // serverConfig detail cache
  ServerConfigResponse _serverConfigDetail =
      ServerConfigResponse("", "", 0, "", "", "", "", "");
  ServerConfigResponse get serverConfigDetail {
    return _serverConfigDetail;
  }

  void removeDetail() {
    _serverConfigDetail = ServerConfigResponse("", "", 0, "", "", "", "", "");
  }

  // get detail serverConfig
  // * Mendapatkan serverConfig
  Future<void> getDetail() async {
    setDetailState(ViewState.busy);

    String error = "";
    try {
      final ServerConfigDetailResponse response =
          await _serverConfigService.getServerConfig(_serverConfigIDSaved);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _serverConfigDetail = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    setDetailState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<void>.error(error);
    }
  }

  // return future true jika add serverConfig berhasil
  // memanggil findServerConfig sehingga tidak perlu notifyListener
  Future<bool> addServerConfig(ServerConfigRequest payload) async {
    setState(ViewState.busy);
    String error = "";

    try {
      final MessageResponse response =
          await _serverConfigService.createServerConfig(payload);
      if (response.error != null) {
        error = response.error!.message;
      }
    } catch (e) {
      error = e.toString();
    }

    setState(ViewState.idle);
    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }
    await findServerConfig(loading: false);
    return true;
  }

  // * update image
  // return future true jika update image berhasil
  Future<bool> uploadImage(String id, File file) async {
    String error = "";

    final File fileCompressed = await compressFile(file);

    try {
      final ServerConfigDetailResponse response =
          await _serverConfigService.uploadImage(id, fileCompressed);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        _serverConfigDetail = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }

    notifyListeners();

    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }
    return true;
  }

  // return image url tanpa base jika update image berhasil
  Future<String> uploadImageForpath(File file) async {
    String imageUrl = "";
    String error = "";

    final File fileCompressed = await compressFile(file);

    try {
      final MessageResponse response =
          await _serverConfigService.uploadImageForPath(fileCompressed);
      if (response.error != null) {
        error = response.error!.message;
      } else {
        imageUrl = response.data!;
      }
    } catch (e) {
      error = e.toString();
    }
    if (error.isNotEmpty) {
      return Future<String>.error(error);
    }
    return imageUrl;
  }

  // remove serverConfig
  Future<bool> removeServerConfig(String id) async {
    String error = "";

    try {
      final MessageResponse response =
          await _serverConfigService.deleteServerConfig(id);
      if (response.error != null) {
        error = response.error!.message;
      }
    } catch (e) {
      error = e.toString();
    }

    notifyListeners();
    if (error.isNotEmpty) {
      return Future<bool>.error(error);
    }
    await findServerConfig(loading: false);
    return true;
  }

  // dipanggil ketika data sudah tidak dibutuhkan lagi,
  // di on dispose
  void onClose() {
    removeDetail();
    _serverConfigList = <ServerConfigResponse>[];
  }
}
