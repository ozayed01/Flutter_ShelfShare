import 'package:flutter/material.dart';
import 'package:shle_share/BottomBar/home_Screen.dart';
import 'package:shle_share/widget/post.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class AddRequest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _addRequestState();
  }
}

class _addRequestState extends State<AddRequest> {
  final _requestTextController = TextEditingController();
  var Date = DateTime.now();
  get formattedDate {
    return formatter.format(Date);
  }

  @override
  void dispose() {
    _requestTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var deviceHight = MediaQuery.of(context).size.height;
    return Container(
      height: deviceHight / 1.10,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: SizedBox(
                height: 70,
                child: Text("Post Requst",
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(12),
              height: 5 * 24.0,
              child: const TextField(
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                decoration:
                    InputDecoration(filled: true, hintText: 'Write Here...'),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 26, vertical: 15),
                    ),
                    child: const Text('Post')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
