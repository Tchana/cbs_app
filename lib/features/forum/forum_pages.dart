import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/data/group/group_data.dart';
import 'package:center_for_biblical_studies/features/forum/group_chat_page.dart';
import 'package:center_for_biblical_studies/services/authentication.dart';
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
  final ApiService apiService = ApiService();
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

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(
                'Créer un groupe',
                style: largeStyle32Bold.copyWith(color: CbsColors.primaryBrown),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nom du groupe',
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
                        labelText: 'Description',
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
                          'Groupe privé',
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
                    'Annuler',
                    style: smallStyle18.copyWith(color: CbsColors.primaryBrown),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Veuillez entrer un nom pour le groupe'),
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
  }

  Future<void> _createGroup(String name, String description, bool isPrivate) async {
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Groupe créé avec succès'),
              backgroundColor: CbsColors.successColor,
            ),
          );
        }
      } else {
        if (mounted) {
          setState(() {
            errorMessage = result["message"] ?? "Erreur lors de la création du groupe";
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
                  title: 'Forum',
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
                          Icon(Icons.error_outline, color: CbsColors.errorColor),
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
                          'Aucun groupe disponible',
                          style: smallStyle18.copyWith(
                            color: CbsColors.primaryBrown,
                          ),
                        ),
                        gapH8,
                        Text(
                          'Créez votre premier groupe pour commencer',
                          style: smallStyle18.copyWith(
                            color: CbsColors.hintColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                else
                  Obx(() => ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: dataController.groups.length,
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
          'Créer un groupe',
          style: smallStyle18.copyWith(color: CbsColors.white),
        ),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final GroupData group;

  const _GroupCard({required this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GroupChatPage(group: group),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                group.name ?? 'Sans nom',
                                style: largeStyle32Bold.copyWith(
                                  fontSize: 20,
                                  color: CbsColors.primaryBrown,
                                ),
                              ),
                            ),
                            if (group.is_private == true)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: CbsColors.primaryBrown.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.lock,
                                      size: 14,
                                      color: CbsColors.primaryBrown,
                                    ),
                                    gapW4,
                                    Text(
                                      'Privé',
                                      style: smallStyle18.copyWith(
                                        fontSize: 12,
                                        color: CbsColors.primaryBrown,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        if (group.description != null && group.description!.isNotEmpty) ...[
                          gapH8,
                          Text(
                            group.description!,
                            style: smallStyle18.copyWith(
                              color: CbsColors.hintColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              gapH12,
              Row(
                children: [
                  Icon(
                    Icons.people,
                    size: 16,
                    color: CbsColors.primaryBrown,
                  ),
                  gapW4,
                  Text(
                    '${group.participants_count ?? 0} participants',
                    style: smallStyle18.copyWith(
                      fontSize: 14,
                      color: CbsColors.primaryBrown,
                    ),
                  ),
                  gapW16,
                  if (group.online_count != null && group.online_count! > 0) ...[
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: CbsColors.successColor,
                    ),
                    gapW4,
                    Text(
                      '${group.online_count} en ligne',
                      style: smallStyle18.copyWith(
                        fontSize: 14,
                        color: CbsColors.successColor,
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (group.created_at != null)
                    Text(
                      _formatDate(group.created_at!),
                      style: smallStyle18.copyWith(
                        fontSize: 12,
                        color: CbsColors.hintColor,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return "Aujourd'hui";
      } else if (difference.inDays == 1) {
        return "Hier";
      } else if (difference.inDays < 7) {
        return "Il y a ${difference.inDays} jours";
      } else {
        return "${date.day}/${date.month}/${date.year}";
      }
    } catch (e) {
      return dateString;
    }
  }
}
