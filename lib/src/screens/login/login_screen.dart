import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:risa2/src/providers/auth.dart';
import 'package:risa2/src/router/routes.dart';
import 'package:risa2/src/widgets/button.dart';

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
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      child: Center(
          child: const Text(
        "RISA LOGIN",
        style: TextStyle(color: Colors.white, fontSize: 25),
      )),
    );
  }
}

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

  void _login(BuildContext context) {
    final authViewModel = Provider.of<AuthModel>(context, listen: false);

    if (_key.currentState?.validate() ?? false) {
      final username = usernameController.text;
      final password = passwordController.text;

      authViewModel.login(username, password);

      if (username == password) {
        final snackBar = SnackBar(
          content: Text('Yay! A SnackBar!'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.of(context).pushNamedAndRemoveUntil(
            RouteGenerator.home, ModalRoute.withName(RouteGenerator.home));
      }
    } else {
      debugPrint("Error :(");
    }
  }

  @override
  Widget build(BuildContext context) {
    const enabledOutlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        borderSide: BorderSide(color: Colors.grey, width: 1));

    const focusedOutlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
        borderSide: BorderSide(color: Color(0xff4643D3), width: 1));

    const errorOutlineInputBorder = OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(25)),
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
            SizedBox(
              height: 10,
            ),
            Consumer<AuthModel>(
                builder: (_, auth, __) => RisaButton(
                    title: "login",
                    onPress: () {
                      _login(context);
                    }))
          ],
        ));
  }
}
