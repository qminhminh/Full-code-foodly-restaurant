import 'package:flutter/material.dart';
import 'package:foodly_restaurant/models/environment.dart';
import 'package:foodly_restaurant/models/user_chat_model.dart';

import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class Message extends StatefulWidget {
  const Message({super.key, required this.item});
  final UserChat item;

  @override
  State<Message> createState() => _ChatRestaurantState();
}

class _ChatRestaurantState extends State<Message> {
  final TextEditingController _messageController = TextEditingController();
  final box = GetStorage();
  String? restaurantId;

  late IO.Socket socket;
  List<Map<String, dynamic>> messages = [];
  List<Map<String, dynamic>> filteredMessages = [];

  @override
  void initState() {
    super.initState();
    restaurantId = box.read('restaurantId');
    _connectToServer();
    _loadChatHistory();
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
      //Get.snackbar('Connection', 'Connected to server');
      socket.emit('join_room', {
        'restaurantId': restaurantId,
        'customerId': widget.item.customerId.id,
      });
    });

    socket.on('receive_message', (data) {
      setState(() {
        messages.add({
          'message': data['message'],
          'sender': data['sender'],
          'id': data['_id'], // Ensure we receive ID for new messages
        });
        filteredMessages.add({
          'message': data['message'],
          'sender': data['sender'],
          'id': data['_id'], // Ensure we receive ID for new messages
        });
      });
    });

    socket.on('message_deleted', (data) {
      setState(() {
        messages.removeWhere((msg) => msg['_id'] == data['messageId']);
        filteredMessages.removeWhere((msg) => msg['_id'] == data['messageId']);
      });
      Get.snackbar("Success", "Message deleted successfully");
    });
  }

  Future<void> _loadChatHistory() async {
    final url = Uri.parse(
      '${Environment.appBaseUrl}/api/chats/messages/$restaurantId/${widget.item.customerId.id}'
          .replaceAll('"', ''),
    );

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
      socket.emit('send_message', {
        'restaurantId': restaurantId,
        'customerId': widget.item.customerId.id,
        'message': message,
        'sender': restaurantId,
      });
      setState(() {
        messages.add({
          'message': message,
          'sender': restaurantId,
          'id': '', // Thêm trình giữ chỗ cho các tin nhắn mới
        });
        filteredMessages.add({
          'message': message,
          'sender': restaurantId,
          'id': '', // Add a placeholder for new messages
        });
        _messageController.clear();
      });
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
                  socket.emit('edit_message', {
                    'restaurantId': restaurantId,
                    'customerId': widget.item.customerId.id,
                    'messageId': messages[index]['id'],
                    'message': updatedMessage,
                  });
                  setState(() {
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
                socket.emit('delete_message', {
                  'restaurantId': restaurantId,
                  'customerId': widget.item.customerId.id,
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
        backgroundColor: Colors.white,
        title: Text(
          widget.item.customerId.username,
          style: const TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Search function
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredMessages.length,
              itemBuilder: (context, index) {
                final message = filteredMessages[index];
                final isCustomer = message['sender'] == restaurantId;
                return Align(
                  alignment:
                      isCustomer ? Alignment.centerRight : Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: isCustomer
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      PopupMenuButton<int>(
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
                      ),
                      const SizedBox(width: 2),
                      Container(
                        width: 100,
                        margin: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color:
                              isCustomer ? Colors.blue[100] : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                message['message'],
                                softWrap: true, // Bật tính năng xuống dòng
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            color: Colors.grey[200],
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
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
