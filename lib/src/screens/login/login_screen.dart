import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../config/pallatte.dart';
import '../../providers/auth.dart';
import '../../router/routes.dart';
import '../../shared/button.dart';
import '../../shared/func_flushbar.dart';
import '../../shared/ui_helpers.dart';
import '../../utils/enums.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: LayoutBuilder(builder: (context, constraint) {
          return SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: <Widget>[
                Upper(constraint.maxHeight * 0.5, constraint.maxWidth),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: LoginForm())
              ],
            ),
          );
        }));
  }
}

class Upper extends StatelessWidget {
  final double height;
  final double width;
  const Upper(this.height, this.width);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
          color: Pallete.background,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (screenIsPortrait(context))
            SizedBox(
              height: 100,
              child: Image.asset('assets/icon/icon.png'),
            ),
          verticalSpaceSmall,
          const Text(
            "RISA",
            style: TextStyle(color: Colors.black, fontSize: 25),
          ),
          verticalSpaceMedium
        ],
      )),
    );
  }
}

// FORM -------------------------------------------------------------
class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final authViewModel = context.read<AuthProvider>();

    if (_key.currentState?.validate() ?? false) {
      final username = usernameController.text;
      final password = passwordController.text;

      Future.delayed(Duration.zero, () {
        authViewModel.login(username, password).then((value) {
          if (value) {
            Future.delayed(Duration(milliseconds: 500), () {
              Navigator.of(context).pushNamedAndRemoveUntil(RouteGenerator.home,
                  ModalRoute.withName(RouteGenerator.home));
            });
          }
        }).onError((error, _) {
          if (error != null) {
            showToastError(
                context: context, message: error.toString(), onTop: true);
          }
        });
      });
    } else {
      debugPrint("Error :(");
    }
  }

  @override
  Widget build(BuildContext context) {
    const enabledOutlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Pallete.secondaryBackground, width: 1));

    const focusedOutlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.grey, width: 1));

    const errorOutlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Colors.red, width: 1));

    return Form(
        key: _key,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(
                    enabledBorder: enabledOutlineInputBorder,
                    focusedBorder: focusedOutlineInputBorder,
                    errorBorder: errorOutlineInputBorder,
                    focusedErrorBorder: errorOutlineInputBorder,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                    labelText: "Username"),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'username tidak boleh kosong';
                  }
                  return null;
                },
                controller: usernameController,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(
                    enabledBorder: enabledOutlineInputBorder,
                    focusedBorder: focusedOutlineInputBorder,
                    errorBorder: errorOutlineInputBorder,
                    focusedErrorBorder: errorOutlineInputBorder,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Password"),
                obscureText: true,
                validator: (text) {
                  if (text == null || text.length < 7) {
                    return 'Password setidaknya 7 karakter';
                  }
                  return null;
                },
                controller: passwordController,
              ),
            ),
            verticalSpaceSmall,
            Consumer<AuthProvider>(
              builder: (_, data, __) {
                return (data.state == ViewState.busy)
                    ? const CircularProgressIndicator()
                    : RisaButton(title: "login", onPress: _login);
              },
            )
          ],
        ));
  }
}
