import 'package:flutter/material.dart';
import 'package:shle_share/BottomBar/Profile/finished_book.dart';
import 'package:shle_share/Screens/chat/chat.dart';
import 'package:shle_share/models/request.dart';
import 'package:shle_share/widget/user_profile.dart';

class RequestDetails extends StatelessWidget {
  const RequestDetails({
    super.key,
    required this.request,
  });
  final Request request;

  @override
  Widget build(BuildContext context) {
    final List<String> details = ['Book: ', "Author: ", "Realase Date: "];
    for (int i = 0; i < 3; i++) {
      details[i] = "${details[i]}${request.bookDtails[i]}.";
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('@${request.user.username} request details'),
      ),
      body: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            //pic and user Details
            Container(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UserProfile(user: request.user),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                            radius: 29,
                            backgroundColor: Colors.grey,
                            foregroundImage:
                                NetworkImage(request.user.userImgUrl)),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          children: [
                            Text(request.user.name,
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            Text(
                              '@${request.user.username}',
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    request.exhangeText,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var detail in details)
                              Text(
                                detail,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          request.bookimgUrl,
                          height: 160,
                          width: 100,
                        ),
                      ),
                      const SizedBox(width: 20)
                    ],
                  ),
                  const SizedBox(height: 25),
                  Text(
                    '${request.user.name} Finished The following Books you can Exchange ${request.bookDtails[0]} with any one of them: ',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),

            Container(
              height: 50,
              color: Theme.of(context).colorScheme.primary,
              child: Center(
                child: Text(
                  '${request.user.name}\'s Books',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.background),
                ),
              ),
            ),
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(3),
                    child: FinishedBook(userId: request.user.userId))),
            const SizedBox(height: 10),
            Text('Or You Can Ask him if he has other Books:',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium),
            TextButton.icon(
                onPressed: () {
                  final message =
                      "Hey ${request.user.name} I would like to Exchange the book ( ${request.bookDtails[0]} ) With one of Your Books";
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChatScreen(
                            useId: request.user.userId,
                            text: message,
                          )));
                },
                icon: const Icon(Icons.mail_rounded),
                label: Text('Contact ${request.user.name}'))
          ],
        ),
      ),
    );
  }
}
