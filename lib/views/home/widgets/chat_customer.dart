// ignore_for_file: library_prefixes

import 'package:flutter/material.dart';
import 'package:foodly_restaurant/constants/constants.dart';
import 'package:foodly_restaurant/models/environment.dart';
import 'package:foodly_restaurant/models/user.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class ChatCustomer extends StatefulWidget {
  const ChatCustomer({super.key, required this.customer});
  final User customer;

  @override
  State<ChatCustomer> createState() => _ChatCustomerState();
}

class _ChatCustomerState extends State<ChatCustomer> {
  final TextEditingController _messageController = TextEditingController();
  final box = GetStorage();
  late final String uid;
  late IO.Socket socket;
  List<Map<String, dynamic>> messages = [];
  List<Map<String, dynamic>> filteredMessages = [];

  @override
  void initState() {
    super.initState();
    uid = box.read("restaurantId").replaceAll('"', '');
    _connectToServer();
    _loadChatHistory().then((_) {
      _markMessagesAsRead();
    });
  }

  void _markMessagesAsRead() {
    // Lọc ra những tin nhắn có sender khác với uid của người dùng
    final unreadMessages = messages
        .where((msg) => msg['sender'] != uid && msg['isRead'] == 'unread')
        .toList();

    if (unreadMessages.isNotEmpty) {
      socket.emit('mark_as_read_res_client', {
        'customerId': widget.customer.id,
        'restaurantId': uid,
      });

      setState(() {
        for (var msg in unreadMessages) {
          msg['isRead'] =
              'read'; // Cập nhật các tin nhắn đủ điều kiện là đã đọc
        }
        for (var msg in filteredMessages) {
          if (msg['sender'] != uid && msg['isRead'] == 'unread') {
            msg['isRead'] = 'read';
          }
        }
      });
    }
  }

  void _sendUnreadNotification(Map<String, dynamic> data) {
    socket.emit('send_unread_notification_res_to_client', {
      'customerId': widget.customer.id,
      'restaurantId': uid,
      'message': data['message'],
    });
  }

  void _connectToServer() {
    socket = IO.io(
      'http://192.168.137.1:5000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();
    socket.onConnect((_) {
      // Get.snackbar('Connection', widget.customer.id);
      socket.emit('join_room_restaurant_client', {
        'customerId': widget.customer.id,
        'restaurantId': uid,
      });
    });

    socket.on('receive_message_res_client', (data) {
      setState(() {
        messages.add({
          'message': data['message'],
          'sender': data['sender'],
          'id': data['_id'],
          'isRead': data['isRead'] ?? 'unread',
        });
        filteredMessages.add({
          'message': data['message'],
          'sender': data['sender'],
          'id': data['_id'],
          'isRead': data['isRead'] ?? 'unread',
        });
      });
      if (data['isRead'] == 'unread') {
        _sendUnreadNotification(data);
      }
      _markMessagesAsRead();
      // _loadChatHistory();
    });

    socket.on('message_deleted', (data) {
      setState(() {
        messages.removeWhere((msg) => msg['_id'] == data['messageId']);
        filteredMessages.removeWhere((msg) => msg['_id'] == data['messageId']);
      });
      _loadChatHistory();
      //Get.snackbar("Success", "Message deleted successfully");
    });

    socket.on('messages_marked_as_read', (data) {
      setState(() {
        // Cập nhật trạng thái của các tin nhắn trong messages
        for (var messageId in data['messageIds']) {
          final index = messages.indexWhere((msg) => msg['id'] == messageId);
          if (index != -1) {
            messages[index]['isRead'] = 'read';
          }
        }

        // Cập nhật trạng thái của các tin nhắn trong filteredMessages
        for (var messageId in data['messageIds']) {
          final index =
              filteredMessages.indexWhere((msg) => msg['id'] == messageId);
          if (index != -1) {
            filteredMessages[index]['isRead'] = 'read';
          }
        }
      });
    });
  }

  Future<void> _loadChatHistory() async {
    final url = Uri.parse(
        '${Environment.appBaseUrl}/api/chats/messages/$uid/${widget.customer.id}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> chatHistory = json.decode(response.body);
        setState(() {
          messages = chatHistory.map((msg) {
            return {
              'message': msg['message'],
              'sender': msg['sender'],
              'id': msg['_id'] ?? '',
              'isRead': msg['isRead'] ?? 'unread',
            };
          }).toList();
          filteredMessages = List.from(messages);
        });
      } else {
        Get.snackbar("Error", "Failed to load chat history");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      final message = _messageController.text;
      socket.emit('send_message_res_client', {
        'customerId': widget.customer.id,
        'restaurantId': uid,
        'message': message,
        'sender': uid,
      });
      setState(() {
        messages.add({
          'message': message,
          'sender': uid,
          'id': '', // Thêm trình giữ chỗ cho các tin nhắn mới
        });
        filteredMessages.add({
          'message': message,
          'sender': uid,
          'id': '', // Add a placeholder for new messages
        });
        _messageController.clear();
      });
      _loadChatHistory();
    }
  }

  void _editMessage(int index) {
    final editedMessage = messages[index]['message'];
    _messageController.text = editedMessage;

    // Use a dialog for editing
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Message"),
          content: TextField(
            controller: _messageController,
            decoration: const InputDecoration(hintText: 'Edit your message...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final updatedMessage = _messageController.text;
                if (updatedMessage.isNotEmpty) {
                  socket.emit('edit_message_res_client', {
                    'customerId': widget.customer.id,
                    'restaurantId': uid,
                    'messageId': messages[index]['id'],
                    'message': updatedMessage,
                  });
                  setState(() {
                    _loadChatHistory();
                    messages[index]['message'] = updatedMessage;
                    filteredMessages[index]['message'] =
                        updatedMessage; // Update filteredMessages too
                    _messageController.clear();
                    Navigator.of(context).pop(); // Close the dialog
                  });
                }
              },
              child: const Text("Update"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _deleteMessage(int index) {
    final message = messages[index];

    // Show confirmation dialog before deletion
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Message"),
          content: const Text("Are you sure you want to delete this message?"),
          actions: [
            TextButton(
              onPressed: () {
                socket.emit('delete_message_res_client', {
                  'customerId': widget.customer.id,
                  'restaurantId': uid,
                  'messageId': message['id'],
                });

                // Remove message locally
                setState(() {
                  messages.removeAt(index);
                  filteredMessages.removeAt(index);
                });

                Get.snackbar("Success", "Message deleted successfully");
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    socket.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: Text(
          widget.customer.username,
          style: const TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back(result: true);
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredMessages.length,
              itemBuilder: (context, index) {
                final message = filteredMessages[index];
                final isCustomer = message['sender'] == uid;

                return Align(
                  alignment:
                      isCustomer ? Alignment.centerRight : Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: isCustomer
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      isCustomer
                          ? PopupMenuButton<int>(
                              icon: const Icon(Icons.more_vert),
                              onSelected: (value) {
                                if (value == 1) {
                                  _editMessage(index);
                                } else if (value == 2) {
                                  _deleteMessage(index);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 1,
                                  child: Text("Edit"),
                                ),
                                const PopupMenuItem(
                                  value: 2,
                                  child: Text("Delete"),
                                ),
                              ],
                            )
                          : const SizedBox(),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color:
                              isCustomer ? Colors.blue[100] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message['message'],
                              softWrap: true,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            // Thêm widget trạng thái đọc ở đây
                            isCustomer
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      // Kiểm tra xem tin nhắn đã đọc hay chưa
                                      Icon(
                                        message['isRead'] == 'read'
                                            ? Icons.check_box
                                            : Icons.not_interested_sharp,
                                        size: 12.0,
                                        color: message['isRead'] == 'read'
                                            ? Colors.green
                                            : Colors.grey,
                                      ),
                                      const SizedBox(
                                          width:
                                              4.0), // Khoảng cách giữa icon và text
                                      Text(
                                        message['isRead'] == 'read'
                                            ? 'read'
                                            : 'unread',
                                        style: TextStyle(
                                          color: message['isRead'] == 'read'
                                              ? Colors.green
                                              : Colors.grey,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius:
                        BorderRadius.circular(25), // Bo tròn nhiều hơn
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8), // Khoảng cách giữa ô nhập và nút gửi
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue, // Đổi màu nền nút gửi
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: _sendMessage,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
