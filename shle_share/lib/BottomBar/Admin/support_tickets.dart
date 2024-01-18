import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shle_share/BottomBar/Admin/ticket_info.dart';
import 'package:shle_share/models/UserChatInfo.dart';

class SupportTickts extends StatefulWidget {
  @override
  State<SupportTickts> createState() => _SupportTicktsState();
}

class _SupportTicktsState extends State<SupportTickts> {
  Future<List<Ticket>> fetchTickets() async {
    // Fetch tickets
    var ticketsQuerySnapshot =
        await FirebaseFirestore.instance.collection('Tickets').get();
    List<Ticket> tickets = [];

    for (var doc in ticketsQuerySnapshot.docs) {
      var ticket = Ticket(
        id: doc.id,
        ticketText: doc['TicketText'],
        userId: doc['userId'],
        createdAt: doc['createdAt'],
      );
      tickets.add(ticket);
    }

    return tickets;
  }

  Future<UserChatInfo> fetchUserDetails(String userId) async {
    // Fetch user details
    var userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    return UserChatInfo(
        userId: userDoc.id,
        name: userDoc['full_name'],
        userImgUrl: userDoc['userPicUrl'],
        userbio: userDoc['Bio'],
        username: userDoc['username']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Tickets'),
      ),
      body: FutureBuilder<List<Ticket>>(
        future: fetchTickets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No tickets found'));
          }

          var tickets = snapshot.data!;

          return ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              var ticket = tickets[index];
              return FutureBuilder<UserChatInfo>(
                future: fetchUserDetails(ticket.userId),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    // Optionally, show a placeholder or progress indicator here
                    return ListTile(title: Text(ticket.ticketText));
                  }

                  var user = userSnapshot.data!;
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TicketInfo(
                                user: user,
                                ticket: ticket,
                              )));
                    },
                    title: Text(ticket.ticketText),
                    subtitle: Text('Submitted by: ${user.name}'),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.userImgUrl),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class Ticket {
  final String id;
  final String ticketText;
  final String userId;
  final Timestamp createdAt;

  Ticket(
      {required this.id,
      required this.ticketText,
      required this.userId,
      required this.createdAt});
}
