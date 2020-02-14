import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  String _search;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Pesquisa',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.black,
                fontFamily: 'OpenSans',
              ),
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (text) {
                _search = text;
              },
            ),
            OutlineButton(
              onPressed: () {
                Navigator.pop(context, _search);
              },
              child: Text('Buscar'),
            ),
          ],
        ),
      ),
    );
  }
}
