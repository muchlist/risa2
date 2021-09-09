import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/api/json_models/request/server_config_req.dart';
import 'package:risa2/src/api/json_models/response/server_config_resp.dart';
import 'package:risa2/src/config/constant.dart';
import 'package:risa2/src/providers/conf_server.dart';
import 'package:risa2/src/shared/cached_image_square.dart';

import '../../config/pallatte.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/home_like_button.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';

class AddServerConfigScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text("Tambah Config"),
      ),
      body: AddServerConfigBody(),
    );
  }
}

class AddServerConfigBody extends StatefulWidget {
  @override
  _AddServerConfigBodyState createState() => _AddServerConfigBodyState();
}

class _AddServerConfigBodyState extends State<AddServerConfigBody> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  // image
  String _imagePath = "";
  late File? _image;
  final ImagePicker picker = ImagePicker();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _diffController = TextEditingController();

  void _addServerConfig() {
    if (_imagePath.isEmpty) {
      showToastError(context: context, message: "Gambar tidak boleh kosong!");
      return;
    }
    if (_key.currentState?.validate() ?? false) {
      // Payload
      final ServerConfigRequest payload = ServerConfigRequest(
        title: _titleController.text,
        note: _noteController.text,
        diff: _diffController.text,
        image: _imagePath,
      );

      // Call Provider
      Future<void>.delayed(
          Duration.zero,
          () => context
                  .read<ServerConfigProvider>()
                  .addServerConfig(payload)
                  .then((bool value) {
                if (value) {
                  Navigator.of(context).pop();
                  showToastSuccess(
                      context: context,
                      message: "Berhasil menambahkan ${payload.title}");
                }
              }).onError((Object? error, _) {
                if (error != null) {
                  showToastError(context: context, message: error.toString());
                }
              }));
    }
  }

  Future<void> _getImageAndUpload(
      {required BuildContext context, required ImageSource source}) async {
    final PickedFile? pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      return;
    }

    // compress and upload
    await context
        .read<ServerConfigProvider>()
        .uploadImageForpath(_image!)
        .then((String value) {
      if (value.isNotEmpty) {
        setState(() {
          _imagePath = value;
        });
      }
    }).onError((Object? error, _) {
      showToastError(context: context, message: error.toString());
    });
  }

  @override
  void initState() {
    final List<ServerConfigResponse> configList =
        context.read<ServerConfigProvider>().serverConfigList;
    if (configList.isNotEmpty) {
      _titleController.text = configList.last.title;
      _noteController.text = configList.last.note;
    }
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _diffController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          // Consumer ------------------------------------------------------
          child: Form(
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // * Judul text ------------------------
                const Text(
                  "Judul",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  textInputAction: TextInputAction.next,
                  minLines: 1,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Pallete.secondaryBackground,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: _titleController,
                  validator: (String? text) {
                    if (text == null || text.isEmpty) {
                      return 'Judul tidak boleh kosong';
                    }
                    return null;
                  },
                ),

                verticalSpaceSmall,

                // * Detail text ------------------------
                const Text(
                  "Detail",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  textInputAction: TextInputAction.newline,
                  minLines: 2,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Pallete.secondaryBackground,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: _noteController,
                ),

                verticalSpaceSmall,

                // * DF=ifference text ------------------------
                const Text(
                  "Perbedaan dengan config sebelumnya",
                  style: TextStyle(fontSize: 16),
                ),

                TextFormField(
                  textInputAction: TextInputAction.newline,
                  minLines: 2,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Pallete.secondaryBackground,
                      enabledBorder: InputBorder.none,
                      border: InputBorder.none),
                  controller: _diffController,
                ),

                verticalSpaceRegular,
                if (_imagePath.isNotEmpty)
                  Center(
                    child: CachedImageSquare(
                      urlPath: "${Constant.baseUrl}$_imagePath",
                      width: 200,
                      height: 200,
                    ),
                  ),
                verticalSpaceRegular,

                Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                          onTap: () => _getImageAndUpload(
                              context: context, source: ImageSource.camera),
                          onLongPress: () => _getImageAndUpload(
                              context: context, source: ImageSource.gallery),
                          child: const Icon(CupertinoIcons.camera)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Consumer<ServerConfigProvider>(
                          builder: (_, ServerConfigProvider data, __) {
                        return (data.state == ViewState.busy)
                            ? const Center(child: CircularProgressIndicator())
                            : Center(
                                child: HomeLikeButton(
                                    iconData: CupertinoIcons.add,
                                    text: "Simpan Config",
                                    tapTap: _addServerConfig),
                              );
                      }),
                    ),
                    const Expanded(
                      child: SizedBox.shrink(),
                    )
                  ],
                ),

                verticalSpaceMedium,
              ],
            ),
          )),
    );
  }
}
