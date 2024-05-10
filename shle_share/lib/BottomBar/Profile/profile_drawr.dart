import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shle_share/BottomBar/Admin/support_tickets.dart';


  

class ProfileDrawr extends StatelessWidget {
  const ProfileDrawr({
    super.key,
    required this.isAdmin,
    required this.userId,
  });
  final bool isAdmin;
  final String userId;
  @override
  Widget build(BuildContext context) {
  void deleteAccount() async{
       await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .update({
          'isActive': false,
        });
  }
    confirmDeleteionDialog() {
     return AlertDialog(
          title: const Text('Delete the Account'),
          content: const Text(
              'Are you sure you want to delete your account? This action is irreversible. However, if you change your mind, you have 7 days to cancel the deletion process. After that, your account and all associated data will be permanently removed.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteAccount();
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
  }


    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.primaryContainer,
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
            child: Row(
              children: [
                Icon(
                  Icons.settings,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(
                  width: 18,
                ),
                Text(
                  isAdmin ? 'Admin Preferences' : 'Account Preferences',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20
                      ),
                )
              ],
            ),
          ),
          if (!isAdmin)
            ListTile(
              leading: const Icon(
                Icons.person_remove_alt_1,
                color: Colors.red,
              ),
              title: Text(
                'Delete Your Account',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.red,
                      fontSize: 20,
                    ),
              ),
              onTap:(){ showDialog(
    context: context,
    builder: (BuildContext context) {
      return confirmDeleteionDialog(); // Call the function here
    },
  );}
            ),
          if (isAdmin)
            ListTile(
              leading: Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              title: Text(
                'Users Tickets',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 24,
                    ),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SupportTickts(),
                ));
              },
            ),
          const Spacer(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'Sign Out',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 24,
                  ),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
