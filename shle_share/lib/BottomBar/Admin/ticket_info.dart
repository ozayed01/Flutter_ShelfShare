import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shle_share/BottomBar/Admin/support_tickets.dart';
import 'package:shle_share/models/UserChatInfo.dart';

class TicketInfo extends StatelessWidget {
  const TicketInfo({super.key, required this.ticket, required this.user});
  final Ticket ticket;
  final UserChatInfo user;

  @override
  Widget build(BuildContext context) {
    void deactivateUser(String userId, bool isActive) async {
      if (isActive) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .update({
          'isActive': false,
        });
      } else {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .update({
          'isActive': true,
        });
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(' ${user.name}\'s ticket'),
        ),
        body: Card(
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              width: 1,
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 5,
                ),
                //pic and user Details
                Row(
                  children: [
                    CircleAvatar(
                        radius: 29,
                        backgroundColor: Colors.grey,
                        foregroundImage: NetworkImage(user.userImgUrl)),
                    const SizedBox(
                      width: 5,
                    ),
                    Column(
                      children: [
                        Text(user.name,
                            style: Theme.of(context).textTheme.headlineSmall),
                        Text(
                          '@${user.username}',
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
                //pic and user details end
                //requst
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Ticket Message : " + ticket.ticketText,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 17,
                ),
                const SizedBox(height: 200),
                ElevatedButton(
                    onPressed: () {
                      deactivateUser(user.userId, false);
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('The User Account is Activated'),
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Restore Account'))
              ],
            ),
          ),
        ));
  }
}
