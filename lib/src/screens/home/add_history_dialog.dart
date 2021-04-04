import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:risa2/src/config/pallatte.dart';

class ItemChoice {
  final int id;
  final String label;

  ItemChoice(this.id, this.label);
}

class AddHistoryDialog extends StatefulWidget {
  const AddHistoryDialog({
    Key? key,
  }) : super(key: key);

  @override
  _AddHistoryDialogState createState() => _AddHistoryDialogState();
}

class _AddHistoryDialogState extends State<AddHistoryDialog> {
  final listChoices = <ItemChoice>[
    ItemChoice(1, 'cctv'),
    ItemChoice(2, 'komputer'),
    ItemChoice(3, 'printer'),
    ItemChoice(4, 'handheld'),
    ItemChoice(5, 'software'),
  ];
  var idSelected = 0;

  // final usernameController = TextEditingController();
  // final passwordController = TextEditingController();

  var _isLoading = false;

  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    // usernameController.dispose();
    // passwordController.dispose();
    super.dispose();
  }

  // void _addHistory() {
  //   if (_key.currentState?.validate() ?? false) {
  //     setLoading(true);

  //     final username = usernameController.text;
  //     final password = passwordController.text;

  //     authViewModel.login(username, password).then((value) {
  //       setLoading(false);
  //       if (value) {
  //         Navigator.of(context).pushNamedAndRemoveUntil(
  //             RouteGenerator.home, ModalRoute.withName(RouteGenerator.home));
  //       }
  //     }).onError((error, _) {
  //       setLoading(false);
  //       if (error != null) {
  //         final snackBar = SnackBar(
  //           content: Text(error.toString()),
  //           duration: Duration(seconds: 3),
  //         );
  //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //       }
  //     });
  //   } else {
  //     debugPrint("Error :(");
  //   }
  // }

  void setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Form(
        key: _key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(
              indent: 70,
              endIndent: 70,
              height: 10,
              thickness: 5,
              color: Pallete.secondaryBackground,
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Kategori :",
              style: TextStyle(fontSize: 16),
            ),
            // * Chip choice
            Wrap(
              children: listChoices
                  .map((e) => ChoiceChip(
                        label: Text(
                          e.label,
                          style: (idSelected == e.id)
                              ? TextStyle(color: Colors.white)
                              : TextStyle(),
                        ),
                        selected: idSelected == e.id,
                        selectedColor: Theme.of(context).accentColor,
                        onSelected: (_) => setState(() => idSelected = e.id),
                      ))
                  .toList(),
              spacing: 5,
            ),
            const Text(
              "Perangkat / Software :",
              style: TextStyle(fontSize: 16),
            ),
            Container(
              height: 50,
              width: double.infinity,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(color: Pallete.secondaryBackground),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pilih perangkat",
                      ),
                      IconButton(
                          icon: Icon(CupertinoIcons.search), onPressed: () {})
                    ]),
              ),
            ),
            const Text(
              "Problem",
              style: TextStyle(fontSize: 16),
            ),
            TextFormField(
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Pallete.secondaryBackground,
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none),
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'username tidak boleh kosong';
                }
                return null;
              },
              // controller: usernameController,
            ),
            const Text(
              "Resolve Note",
              style: TextStyle(fontSize: 16),
            ),
            TextFormField(
              decoration: const InputDecoration(
                  filled: true,
                  fillColor: Pallete.secondaryBackground,
                  enabledBorder: InputBorder.none,
                  border: InputBorder.none),
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'username tidak boleh kosong';
                }
                return null;
              },
              // controller: usernameController,
            ),
            DropdownButton<String>(
              items: <String>['A', 'B', 'C', 'D'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (_) {},
            )
          ],
        ),
      ),
    );

    // const enabledOutlineInputBorder = OutlineInputBorder(
    //     borderRadius: BorderRadius.all(Radius.circular(25)),
    //     borderSide: BorderSide(color: Pallete.green, width: 1));

    // const focusedOutlineInputBorder = OutlineInputBorder(
    //     borderRadius: BorderRadius.all(Radius.circular(25)),
    //     borderSide: BorderSide(color: Pallete.green, width: 1));

    // const errorOutlineInputBorder = OutlineInputBorder(
    //     borderRadius: BorderRadius.all(Radius.circular(25)),
    //     borderSide: BorderSide(color: Colors.red, width: 1));

    //   return Form(
    //       key: _key,
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           Padding(
    //             padding: const EdgeInsets.all(4.0),
    //             child: TextFormField(
    //               keyboardType: TextInputType.visiblePassword,
    //               decoration: const InputDecoration(
    //                   enabledBorder: enabledOutlineInputBorder,
    //                   focusedBorder: focusedOutlineInputBorder,
    //                   errorBorder: errorOutlineInputBorder,
    //                   focusedErrorBorder: errorOutlineInputBorder,
    //                   border: OutlineInputBorder(),
    //                   prefixIcon: Icon(Icons.person),
    //                   labelText: "Username"),
    //               validator: (text) {
    //                 if (text == null || text.isEmpty) {
    //                   return 'username tidak boleh kosong';
    //                 }
    //                 return null;
    //               },
    //               controller: usernameController,
    //             ),
    //           ),
    //           Padding(
    //             padding: const EdgeInsets.all(4.0),
    //             child: TextFormField(
    //               keyboardType: TextInputType.visiblePassword,
    //               decoration: const InputDecoration(
    //                   enabledBorder: enabledOutlineInputBorder,
    //                   focusedBorder: focusedOutlineInputBorder,
    //                   errorBorder: errorOutlineInputBorder,
    //                   focusedErrorBorder: errorOutlineInputBorder,
    //                   border: OutlineInputBorder(),
    //                   prefixIcon: Icon(Icons.lock),
    //                   labelText: "Password"),
    //               obscureText: true,
    //               validator: (text) {
    //                 if (text == null || text.length < 7) {
    //                   return 'Password setidaknya 7 karakter';
    //                 }
    //                 return null;
    //               },
    //               controller: passwordController,
    //             ),
    //           ),
    //           SizedBox(
    //             height: 10,
    //           ),
    //           (_isLoading)
    //               ? const CircularProgressIndicator()
    //               : RisaButton(
    //                   title: "login",
    //                   onPress: () {
    //                     _login();
    //                   })
    //         ],
    //       ));
    // }
  }
}
