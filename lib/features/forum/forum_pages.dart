import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/data/group/group_data.dart';
import 'package:center_for_biblical_studies/data/message/message_data.dart';
import 'package:center_for_biblical_studies/features/forum/group_chat_page.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/shared/page_header.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final SupabaseService apiService = SupabaseService();
  final DataController dataController = Get.find<DataController>();
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    if (dataController.groups.isEmpty) {
      fetchGroups();
    }
  }

  Future<void> fetchGroups() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final groups = await apiService.fetchGroups();
      if (mounted) {
        dataController.setGroups(groups);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _showCreateGroupDialog() async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    bool isPrivate = false;

    try {
      await showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          final l10n = AppLocalizations.of(dialogContext) ??
              AppLocalizations(const Locale('fr'));
          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: Text(
                  l10n.createGroup,
                  style:
                      largeStyle32Bold.copyWith(color: CbsColors.primaryBrown),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: l10n.groupName,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: CbsColors.primaryBrown,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      gapH16,
                      TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          labelText: l10n.description,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: CbsColors.primaryBrown,
                              width: 2,
                            ),
                          ),
                        ),
                        maxLines: 3,
                      ),
                      gapH16,
                      Row(
                        children: [
                          Checkbox(
                            value: isPrivate,
                            onChanged: (value) {
                              setDialogState(() {
                                isPrivate = value ?? false;
                              });
                            },
                            activeColor: CbsColors.primaryBrown,
                          ),
                          Text(
                            l10n.privateGroup,
                            style: smallStyle18,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      l10n.cancel,
                      style:
                          smallStyle18.copyWith(color: CbsColors.primaryBrown),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (nameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.groupNameRequired),
                          ),
                        );
                        return;
                      }

                      Navigator.of(context).pop();
                      await _createGroup(
                        nameController.text.trim(),
                        descriptionController.text.trim(),
                        isPrivate,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CbsColors.primaryBrown,
                      foregroundColor: CbsColors.white,
                    ),
                    child: const Text('Créer'),
                  ),
                ],
              );
            },
          );
        },
      );
    } finally {
      // Always dispose controllers to prevent memory leaks
      nameController.dispose();
      descriptionController.dispose();
    }
  }

  Future<void> _createGroup(
      String name, String description, bool isPrivate) async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await apiService.createGroup(
        name: name,
        description: description,
        isPrivate: isPrivate,
      );

      if (result["success"] == true) {
        // Refresh groups list
        await fetchGroups();
        if (mounted) {
          final l10n = AppLocalizations.of(context) ??
              AppLocalizations(const Locale('fr'));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.groupCreatedSuccess),
              backgroundColor: CbsColors.successColor,
            ),
          );
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = result["message"] ??
                (AppLocalizations.of(context) ??
                        AppLocalizations(const Locale('fr')))
                    .groupCreateError;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur: ${e.toString()}'),
            backgroundColor: CbsColors.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchGroups,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.only(top: 60),
            child: Column(
              children: [
                gapH16,
                PageHeader(
                  title: l10n.forum,
                  titleIcon: const Icon(
                    Icons.message,
                    color: CbsColors.primaryBlue,
                  ),
                ),
                gapH32,
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CbsColors.errorColor[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: CbsColors.errorColor),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline,
                              color: CbsColors.errorColor),
                          gapW8,
                          Expanded(
                            child: Text(
                              errorMessage!,
                              style: smallStyle18.copyWith(
                                color: CbsColors.errorColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (isLoading && dataController.groups.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  )
                else if (dataController.groups.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.group_outlined,
                          size: 64,
                          color: CbsColors.primaryBrown.withValues(alpha: 0.5),
                        ),
                        gapH16,
                        Text(
                          l10n.noGroups,
                          style: smallStyle18.copyWith(
                            color: CbsColors.primaryBrown,
                          ),
                        ),
                        gapH8,
                        Text(
                          l10n.createFirst,
                          style: smallStyle18.copyWith(
                            color: CbsColors.hintColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  Obx(() => ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: dataController.groups.length,
                        separatorBuilder: (context, index) => Divider(
                          height: 1,
                          thickness: 1,
                          color: CbsColors.primaryBrown.withValues(alpha: 0.1),
                          indent: 20,
                          endIndent: 20,
                        ),
                        itemBuilder: (context, index) {
                          final group = dataController.groups[index];
                          // Skip deleted groups
                          if (group.is_deleted == true) {
                            return const SizedBox.shrink();
                          }
                          return _GroupCard(group: group);
                        },
                      )),
                gapH32,
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateGroupDialog,
        backgroundColor: CbsColors.primaryBrown,
        icon: const Icon(Icons.add, color: CbsColors.white),
        label: Text(
          l10n.createGroup,
          style: smallStyle18.copyWith(color: CbsColors.white),
        ),
      ),
    );
  }
}

class _GroupCard extends StatefulWidget {
  final GroupData group;

  const _GroupCard({required this.group});

  @override
  State<_GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<_GroupCard> {
  final SupabaseService _apiService = SupabaseService();
  MessageData? _lastMessage;
  bool _isLoadingLastMessage = false;

  @override
  void initState() {
    super.initState();
    _fetchLastMessage();
  }

  Future<void> _fetchLastMessage() async {
    if (widget.group.uuid == null) return;

    setState(() {
      _isLoadingLastMessage = true;
    });

    try {
      final messages = await _apiService.fetchMessages(widget.group.uuid!);
      if (messages.isNotEmpty && mounted) {
        // Get the last message (most recent)
        final sortedMessages = List<MessageData>.from(messages);
        sortedMessages.sort((a, b) {
          if (a.timestamp == null || b.timestamp == null) return 0;
          return b.timestamp!.compareTo(a.timestamp!); // Sort descending
        });

        final lastMsg = sortedMessages.firstWhere(
          (msg) => msg.is_deleted != true,
          orElse: () => sortedMessages.first,
        );

        if (mounted) {
          setState(() {
            _lastMessage = lastMsg;
            _isLoadingLastMessage = false;
          });
        }
      } else if (mounted) {
        setState(() {
          _isLoadingLastMessage = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingLastMessage = false;
        });
      }
    }
  }

  String _formatTime(String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
      } else if (difference.inDays == 1) {
        return "Hier";
      } else if (difference.inDays < 7) {
        return "Il y a ${difference.inDays}j";
      } else {
        return "${date.day}/${date.month}";
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: CbsColors.primaryBrown.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.group,
          color: CbsColors.primaryBrown,
          size: 28,
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              widget.group.name ?? l10n.unnamedGroup,
              style: largeStyle32Bold.copyWith(
                fontSize: 18,
                color: CbsColors.primaryBrown,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.group.is_private == true)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: CbsColors.primaryBrown.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.lock,
                    size: 12,
                    color: CbsColors.primaryBrown,
                  ),
                  gapW4,
                  Text(
                    l10n.private,
                    style: smallStyle18.copyWith(
                      fontSize: 10,
                      color: CbsColors.primaryBrown,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      subtitle: _isLoadingLastMessage
          ? Text(
              l10n.loading,
              style: smallStyle18.copyWith(
                fontSize: 14,
                color: CbsColors.hintColor,
              ),
            )
          : Text(
              _lastMessage?.content ?? l10n.noMessage,
              style: smallStyle18.copyWith(
                fontSize: 14,
                color: CbsColors.hintColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
      trailing: _lastMessage?.timestamp != null
          ? Text(
              _formatTime(_lastMessage!.timestamp),
              style: smallStyle18.copyWith(
                fontSize: 12,
                color: CbsColors.hintColor,
              ),
            )
          : null,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GroupChatPage(group: widget.group),
          ),
        );
      },
    );
  }
}
