import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/theme/investor_colors.dart';
import '../../model/cross_conversation_model.dart';

/// Chat screen for cross-mode conversations with attachments and video call simulation.
class CrossConversationChatScreen extends ConsumerStatefulWidget {
  const CrossConversationChatScreen({super.key, required this.conversation});

  final CrossConversation conversation;

  @override
  ConsumerState<CrossConversationChatScreen> createState() => _CrossConversationChatScreenState();
}

class _CrossConversationChatScreenState extends ConsumerState<CrossConversationChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage([String? textOverride]) {
    final text = textOverride ?? _messageController.text.trim();
    if (text.isEmpty) return;

    ref.read(crossConversationViewModelProvider.notifier).sendMessage(
      widget.conversation.id,
      text,
    );
    _messageController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _showAttachmentSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: InvestorColors.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Share Attachment / Deal Document',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: InvestorColors.ink),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: InvestorColors.goldSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.description_rounded, color: InvestorColors.goldDeep),
                ),
                title: const Text('Share Pitch Deck', style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text('Attach a pitch deck from your library'),
                onTap: () {
                  Navigator.pop(ctx);
                  _sendMessage('📄 Shared Pitch Deck: Series A Presentation.pdf');
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: InvestorColors.greenSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.handshake_rounded, color: InvestorColors.green),
                ),
                title: const Text('Send Term Sheet Draft', style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text('Share initial investment term sheet draft'),
                onTap: () {
                  Navigator.pop(ctx);
                  _sendMessage('📝 Sent Term Sheet Draft for Nova Robotics round.');
                },
              ),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: InvestorColors.blueSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.videocam_rounded, color: InvestorColors.blue),
                ),
                title: const Text('Schedule Investor Call', style: TextStyle(fontWeight: FontWeight.w700)),
                subtitle: const Text('Send invite for 30-min diligence video call'),
                onTap: () {
                  Navigator.pop(ctx);
                  _sendMessage('📅 Invited to 30-min Diligence Video Call via CollabSphere Room.');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(crossConversationViewModelProvider).currentMessages;
    final isStartup = widget.conversation.participant2Role == 'startup';
    final otherName = isStartup ? widget.conversation.participant2Name : widget.conversation.participant1Name;
    final otherAvatar = isStartup ? widget.conversation.participant2Avatar : widget.conversation.participant1Avatar;
    final otherInitials = otherAvatar.length >= 2 ? otherAvatar.substring(0, 2).toUpperCase() : otherAvatar.toUpperCase();
    final otherRole = isStartup ? widget.conversation.participant2Role : widget.conversation.participant1Role;

    return Scaffold(
      backgroundColor: InvestorColors.goldBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: InvestorColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: InvestorColors.colorForKey(otherRole == 'startup' ? 'purple' : 'gold').withValues(alpha: 0.15),
              child: Text(
                otherInitials,
                style: TextStyle(
                  color: InvestorColors.colorForKey(otherRole == 'startup' ? 'purple' : 'gold'),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherName,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w800,
                      color: InvestorColors.ink,
                    ),
                  ),
                  Text(
                    '${otherRole.toUpperCase()} • ${widget.conversation.isOnline ? 'Online' : 'Offline'}',
                    style: TextStyle(
                      fontSize: 11,
                      color: widget.conversation.isOnline ? InvestorColors.green : InvestorColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? _buildEmptyChat()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) => _buildMessageBubble(messages[index]),
                  ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildEmptyChat() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: InvestorColors.goldSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 44,
              color: InvestorColors.goldDeep,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: InvestorColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Send a message or share a deal term sheet to start.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.5, color: InvestorColors.textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(CrossMessage message) {
    final isMe = message.senderId == 'investor-1';
    final children = <Widget>[
      if (!isMe)
        CircleAvatar(
          radius: 14,
          backgroundColor: InvestorColors.colorForKey(message.senderRole == 'startup' ? 'purple' : 'gold').withValues(alpha: 0.15),
          child: Text(
            message.senderAvatar.substring(0, 1).toUpperCase(),
            style: TextStyle(
              color: InvestorColors.colorForKey(message.senderRole == 'startup' ? 'purple' : 'gold'),
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      if (!isMe) const SizedBox(width: 8),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isMe ? InvestorColors.goldDeep : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: isMe ? const Radius.circular(18) : const Radius.circular(4),
              bottomRight: isMe ? const Radius.circular(4) : const Radius.circular(18),
            ),
            border: !isMe ? Border.all(color: InvestorColors.border) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMe)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    message.senderName,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: InvestorColors.textMuted,
                    ),
                  ),
                ),
              Text(
                message.text,
                style: TextStyle(
                  fontSize: 14,
                  color: isMe ? Colors.white : InvestorColors.ink,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
      if (isMe) const SizedBox(width: 8),
      if (isMe)
        CircleAvatar(
          radius: 14,
          backgroundColor: InvestorColors.goldDeep.withValues(alpha: 0.15),
          child: const Text(
            'YU',
            style: TextStyle(
              color: InvestorColors.goldDeep,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: children,
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: InvestorColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file_outlined, color: InvestorColors.goldDeep, size: 22),
              onPressed: _showAttachmentSheet,
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: const TextStyle(color: InvestorColors.textMuted, fontSize: 14),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: InvestorColors.goldDeep, width: 1.5),
                  ),
                ),
                style: const TextStyle(fontSize: 14, color: InvestorColors.ink),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                gradient: InvestorColors.goldShimmer,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                onPressed: () => _sendMessage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}