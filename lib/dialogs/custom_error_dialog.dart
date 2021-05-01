import 'package:flutter/material.dart';

void showErrorDialog(String title, String message, BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: SizedBox(
          height: 200.0,
          width: MediaQuery.of(context).size.width - 100,
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(
                                color: Theme.of(context).primaryColor)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                title,
                                style: Theme.of(context).textTheme.title,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: 24.0,
                                  left: 16.0,
                                  right: 16.0,
                                ),
                                child: Center(
                                  child: Text(
                                    message,
                                    style: Theme.of(context).textTheme.subhead,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 64.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: GestureDetector(
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).primaryColorLight,
                            foregroundColor: Colors.white,
                            child: Image(
                              image: AssetImage('assets/flutterKarachi.png'),
                            ),
                            radius: 30.0,
                          ),
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
