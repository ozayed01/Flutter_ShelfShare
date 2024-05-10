import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shle_share/BottomBar/Profile/profile_drawr.dart';

class AdminUsersList extends StatefulWidget {
  const AdminUsersList({Key? key, required this.AdminName}) : super(key: key);
  final String AdminName;
  @override
  State<AdminUsersList> createState() => _AdminUsersListState();
}

class _AdminUsersListState extends State<AdminUsersList> {
  late Stream<List<DocumentSnapshot>> filteredUsersStream;

  String formatFirestoreTimestampToRegularDate(Timestamp firestoreTimestamp) {
    DateTime dateTime = firestoreTimestamp.toDate();
    DateTime now = DateTime.now();

    Duration difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 3) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  @override
  void initState() {
    super.initState();
    late Stream<QuerySnapshot> usersStream;
    final authUser = FirebaseAuth.instance.currentUser!;
    usersStream = FirebaseFirestore.instance
        .collection('Users')
        .orderBy('userId', descending: false)
        .snapshots();
    filteredUsersStream = usersStream.map((snapshot) {
      return snapshot.docs.where((doc) => doc.id != authUser.uid).toList();
    });
  }

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
      endDrawer: const ProfileDrawr(isAdmin: true, userId: 'hj' , ),
      appBar: AppBar(
        title: Text(
          'Users List (Accessed As ${widget.AdminName})',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.background,
              ),
        ),
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: filteredUsersStream, // Use the filtered stream directly.
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Users were found!'));
          }

          final loadedUsers = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            itemCount: loadedUsers.length,
            itemBuilder: (context, index) {
              final user = loadedUsers[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(
                  user['full_name'] as String,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                leading: CircleAvatar(
                  radius: 25, // Adjusted the radius
                  backgroundColor: Colors.grey,
                  backgroundImage: NetworkImage(user['userPicUrl'] as String),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                subtitle: Row(
                  children: [
                    Text(
                      '@${user['username']}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Spacer(),
                    Text("Joined: ${formatFirestoreTimestampToRegularDate(
                      user['createdAt'] as Timestamp,
                    )}"),
                  ],
                ),
                onTap: () {
                  // Implement navigation or another action on tap.
                },
                trailing: IconButton(
                    onPressed: () {
                      if (user['isActive']) {
                        deactivateUser(user['userId'], true);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('The User Account is Deactivated'),
                          ),
                        );
                      } else {
                        deactivateUser(user['userId'], false);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('The User Account is Activated'),
                          ),
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.remove_circle_sharp,
                      color: Colors.red,
                    )),
              );
            },
          );
        },
      ),
    );
  }
}
