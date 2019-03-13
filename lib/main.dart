import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:yo/friends_model.dart';
import 'package:yo/login_page.dart';
import 'package:yo/session_model.dart';
import 'person.dart';

Future<void> main() async {
  final SessionModel sessionModel = SessionModel();
  runApp(ScopedModel(model: sessionModel, child: YoApp()));
}

class YoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Yo!',
        theme: ThemeData(
          brightness: Brightness.dark,
          accentColor: Color(0xFFF67280),
        ),
        home: ScopedModelDescendant<SessionModel>(
          builder: (BuildContext context, Widget child, SessionModel model) {
            if (!model.initialized) {
              // kind of splash screen, before we know if the user is signed in or not
              return Splash();
            }

            if (model.isUserLoggedIn) {
              // still signed in, show home
              return ScopedModel(
                  model: FriendsModel(model),
                  child: FriendsPage()
                );
            }

            // new user, show login
            return LoginPage();
          },
      )
  );
}
}

class Splash extends StatelessWidget {
  const Splash({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF6C5B7B),
      child: Center(
        child: SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class FriendsPage extends StatelessWidget {

  final List<Color> _colors = [
      Color(0xFFF8B195),
      Color(0xFFF67280),
      Color(0xFFC06C84),
      Color(0xFF6C5B7B),
      Color(0xFF355C7D),
      Color(0xFF34495D),
  ];

  Widget build(BuildContext context) {
    return ScopedModelDescendant<FriendsModel>(
          builder: (BuildContext context, Widget child, FriendsModel model) {
          return ListView.builder(
        padding: EdgeInsets.only(top: 48.0),
        itemCount: model.friends.length,
        itemBuilder: (BuildContext context, int index) {
          return Material(
                      child: InkWell(
              onTap: () {
                FriendsModel.of(context).sendYo(model.friends[index]);
              },
                        child: Container(
                height: 128,
                color: _colors[index % _colors.length],
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ClipOval(
                          child: Image.network(
                            model.friends[index].photoUrl,
                            height: 48,
                            width: 48,
                          ),
                      ),
                    ),
                    Text(
                      model.friends[index].name.toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24
                      ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
          },
    );
  }
}
