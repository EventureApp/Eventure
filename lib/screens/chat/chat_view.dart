import 'package:eventure/providers/chat_provider.dart';
import 'package:eventure/providers/user_provider.dart';
import 'package:eventure/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class Chat extends StatefulWidget {
  final String eventId;

  const Chat({
    super.key,
    required this.eventId,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_ChatState');
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ChatProvider>(context, listen: false)
        .startListeningToChatMessages(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, _) {
          final messages = chatProvider.chatMessages;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Leave a message',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your message to continue';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      StyledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final user = context
                                .read<AuthenticationProvider>()
                                .currentUser;
                            if (user != null) {
                              await chatProvider.addMessage(
                                _controller.text,
                                user.uid,
                                widget.eventId,
                              );
                              _controller.clear();
                            }
                          }
                        },
                        child: const Row(
                          children: [
                            Icon(Icons.send),
                            SizedBox(width: 4),
                            Text('SEND'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Flexible(
                fit: FlexFit.loose,
                child: messages.isEmpty
                    ? const Center(child: Text('No messages yet'))
                    : ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return Paragraph(
                              '${Provider.of<UserProvider>(context).getUserName(message.userId)}: ${message.text}');
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
