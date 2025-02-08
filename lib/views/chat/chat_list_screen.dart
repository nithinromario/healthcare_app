import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/navigation_service.dart';

class ChatListScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  const ChatListScreen({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: FirebaseAuth.instance.currentUser?.uid)
            .orderBy('lastMessageTime', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final chats = snapshot.data?.docs ?? [];

          if (chats.isEmpty) {
            return const Center(
              child: Text('No chats found'),
            );
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index].data() as Map<String, dynamic>;
              final otherUserId = (chat['participants'] as List)
                  .firstWhere((id) => id != FirebaseAuth.instance.currentUser?.uid);

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherUserId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const ListTile(
                      leading: CircleAvatar(child: Icon(Icons.person)),
                      title: Text('Loading...'),
                    );
                  }

                  final otherUser = userSnapshot.data!.data() as Map<String, dynamic>;

                  return ListTile(
                    leading: CircleAvatar(
                      child: Text(
                        (otherUser['name'] as String?)?.substring(0, 1).toUpperCase() ?? '?',
                      ),
                    ),
                    title: Text(otherUser['name'] ?? 'Unknown User'),
                    subtitle: Text(
                      chat['lastMessage'] ?? 'No messages yet',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: chat['unreadCount'] > 0
                        ? CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.blue,
                            child: Text(
                              chat['unreadCount'].toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : null,
                    onTap: () {
                      NavigationService.navigateTo(
                        NavigationService.chatRoom,
                        arguments: {
                          'chatId': chats[index].id,
                          'otherUser': otherUser,
                        },
                      );
                    },
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
