import 'package:eventure/providers/chat_provider.dart';
import 'package:eventure/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/event_provider.dart';
import 'chat_message_group.dart';
import 'chat_message_user.dart';

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

  Widget _buildMessages(BuildContext context, String eventId) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        final messages = chatProvider.chatMessages;

        return Expanded(
          child: messages.isEmpty
              ? const Center(child: Text('No messages yet'))
              : ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isSentByUser = message.userId ==
                        context.read<AuthenticationProvider>().currentUser?.uid;
                    if (isSentByUser) {
                      return ChatMessageUser(message: message.text);
                    } else {
                      final userName = Provider.of<UserProvider>(context)
                          .getUser(message.userId);

                      return ChatMessageGroup(
                        message: message.text,
                        userFuture: userName,
                      );
                    }
                  },
                ),
        );
      },
    );
  }

  Widget _buildInputArea(BuildContext context, String eventId) {
    return Container(
      padding: const EdgeInsets.only(
        bottom: 25.0,
        left: 8.0,
        right: 8.0,
        top: 4.0,
      ),
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  filled: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
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
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final user =
                      context.read<AuthenticationProvider>().currentUser;
                  if (user != null) {
                    await Provider.of<ChatProvider>(context, listen: false)
                        .addMessage(
                      _controller.text,
                      user.uid,
                      eventId,
                    );
                    _controller.clear();
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final event = context.read<EventProvider>().getEventFromId(widget.eventId);
    final eventName = event.name;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        title: Text(eventName),
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.surface,
            width: double.infinity,
            // height: 100,
            padding: const EdgeInsets.symmetric(vertical: 13),
            child: Center(
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
                child: Center(
                  child: Icon(
                    Icons.message,
                    size: 30,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          _buildMessages(context, widget.eventId),
          _buildInputArea(context, widget.eventId),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
