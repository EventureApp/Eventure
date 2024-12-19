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
                    return Paragraph(
                      '${Provider.of<UserProvider>(context).getUserName(message.userId)}: ${message.text}',
                    );
                  },
                ),
        );
      },
    );
  }

  Widget _buildInputArea(BuildContext context, String eventId) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
        left: 8.0,
        right: 8.0,
        top: 4.0,
      ),
      color: Theme.of(context).colorScheme.background,
      child: Form(
        key: _formKey,
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _controller,
                decoration: InputDecoration(
                  filled: true,
                  labelStyle:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            color: Theme.of(context).colorScheme.surface,
            width: double.infinity,
            height: 100,
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
          // Messages List
          _buildMessages(context, widget.eventId),
          // Input Area
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
