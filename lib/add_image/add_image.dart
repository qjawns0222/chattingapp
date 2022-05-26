import 'package:flutter/material.dart';

class Add_image extends StatefulWidget {
  const Add_image({Key? key}) : super(key: key);

  @override
  State<Add_image> createState() => _Add_imageState();
}

class _Add_imageState extends State<Add_image> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        width: 150,
        height: 300,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 150,
              child: OutlinedButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image),
                    Text('Add icon'),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.close),
                  Text('Close'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
