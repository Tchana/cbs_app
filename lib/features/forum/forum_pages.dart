import 'package:center_for_biblical_studies/data/controllers/data_controller.dart';
import 'package:center_for_biblical_studies/data/group/group_data.dart';
import 'package:center_for_biblical_studies/data/message/message_data.dart';
import 'package:center_for_biblical_studies/features/forum/group_chat_page.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/responsiveness/breakpoints.dart';
import 'package:center_for_biblical_studies/responsiveness/desktop_campus_ui.dart';
import 'package:center_for_biblical_studies/responsiveness/desktop_page_frame.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({
    super.key,
    SupabaseService? apiService,
  }) : apiService = apiService ?? const SupabaseService.testable();

  final SupabaseService apiService;

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final DataController dataController = Get.find<DataController>();
  bool isLoading = false;
  String? errorMessage;
  String? _selectedGroupUuid;

  @override
  void initState() {
    super.initState();
    if (dataController.groups.isEmpty) {
      fetchGroups();
    } else {
      _ensureSelectedGroup(dataController.groups, notify: false);
    }
  }

  List<GroupData> get _visibleGroups => dataController.groups
      .where((group) => group.is_deleted != true)
      .toList();

  GroupData? get _selectedGroup {
    final id = _selectedGroupUuid;
    if (id == null) return null;
    for (final group in _visibleGroups) {
      if (group.uuid == id) return group;
    }
    return null;
  }

  void _ensureSelectedGroup(List<GroupData> groups, {bool notify = true}) {
    final visible = groups.where((g) => g.is_deleted != true).toList();
    if (visible.isEmpty) {
      if (_selectedGroupUuid != null) {
        if (notify && mounted) {
          setState(() => _selectedGroupUuid = null);
        } else {
          _selectedGroupUuid = null;
        }
      }
      return;
    }

    final stillValid =
        _selectedGroupUuid != null &&
            visible.any((g) => g.uuid == _selectedGroupUuid);
    if (!stillValid) {
      final nextId = visible.first.uuid;
      if (notify && mounted) {
        setState(() => _selectedGroupUuid = nextId);
      } else {
        _selectedGroupUuid = nextId;
      }
    }
  }

  Future<void> fetchGroups() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final groups = await widget.apiService.fetchGroups();
      if (mounted) {
        dataController.setGroups(groups);
        _ensureSelectedGroup(groups);
      }
    } catch (e) {
      if (mounted) {
        final l10n =
            AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
        setState(() {
          errorMessage = l10n.unknownError;
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
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final messenger = ScaffoldMessenger.of(context);
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => const _CreateRoomPage()),
    );
    if (created == true) {
      if (!mounted) return;
      await fetchGroups();
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.groupCreatedSuccess),
          backgroundColor: CbsColors.successColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = Adaptive.isDesktop(context);

    return Scaffold(
      backgroundColor: isDark ? CbsColors.darkBg : CbsColors.brandIvory,
      body: DesktopPageFrame(
        padding: isDesktop
            ? const EdgeInsets.fromLTRB(12, 12, 12, 12)
            : EdgeInsets.zero,
        child: isDesktop
            ? _buildDesktopForum(context, l10n, isDark)
            : _buildMobileForum(context, l10n, isDark),
      ),
      floatingActionButton: isDesktop
          ? null
          : FloatingActionButton(
              onPressed: _showCreateGroupDialog,
              elevation: 3,
              backgroundColor: CbsColors.brandGold,
              foregroundColor: CbsColors.brownNight,
              child: const Icon(Icons.add_rounded, size: 26),
            ),
    );
  }

  Widget _buildMobileForum(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return RefreshIndicator(
      color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
      onRefresh: fetchGroups,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: isDark ? CbsColors.darkBg : CbsColors.brandIvory,
            surfaceTintColor: Colors.transparent,
            title: Text(
              l10n.forum,
              style: smallStyle18.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 22,
                color: isDark
                    ? CbsColors.darkTextPrimary
                    : CbsColors.primaryBrown,
              ),
            ),
            actions: [
              IconButton(
                onPressed: fetchGroups,
                icon: const Icon(Icons.refresh_rounded),
                tooltip: l10n.refresh,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: _ForumHeroBanner(l10n: l10n, isDark: isDark),
            ),
          ),
          if (errorMessage != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: _ForumErrorBanner(message: errorMessage!),
              ),
            ),
          Obx(() {
            final groups = _visibleGroups;

            if (isLoading && groups.isEmpty) {
              return const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (groups.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: _ForumEmptyState(
                  l10n: l10n,
                  isDark: isDark,
                  onCreate: _showCreateGroupDialog,
                ),
              );
            }

            return SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 88),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _GroupCard(
                        group: groups[index],
                        apiService: widget.apiService,
                      ),
                    );
                  },
                  childCount: groups.length,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDesktopForum(
    BuildContext context,
    AppLocalizations l10n,
    bool isDark,
  ) {
    return Obx(() {
      final groups = _visibleGroups;
      final selected = _selectedGroup;

      return Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 320,
            child: CampusCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DesktopForumRoomsHeader(
                    l10n: l10n,
                    isDark: isDark,
                    onRefresh: fetchGroups,
                    onCreate: _showCreateGroupDialog,
                  ),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                      child: _ForumErrorBanner(message: errorMessage!),
                    ),
                  Expanded(
                    child: isLoading && groups.isEmpty
                        ? Center(
                            child: CircularProgressIndicator(
                              color: isDark
                                  ? CbsColors.brandGold
                                  : CbsColors.primaryBrown,
                            ),
                          )
                        : groups.isEmpty
                            ? _DesktopForumEmptyRooms(
                                l10n: l10n,
                                isDark: isDark,
                                onCreate: _showCreateGroupDialog,
                              )
                            : ListView.separated(
                                padding: const EdgeInsets.fromLTRB(
                                  12,
                                  4,
                                  12,
                                  12,
                                ),
                                itemCount: groups.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 8),
                                itemBuilder: (context, index) {
                                  final group = groups[index];
                                  return _DesktopForumRoomTile(
                                    group: group,
                                    l10n: l10n,
                                    isDark: isDark,
                                    selected:
                                        group.uuid == _selectedGroupUuid,
                                    onTap: () {
                                      setState(
                                        () => _selectedGroupUuid = group.uuid,
                                      );
                                    },
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CampusCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DesktopForumChatHeader(
                    group: selected,
                    l10n: l10n,
                    isDark: isDark,
                  ),
                  Expanded(
                    child: selected == null
                        ? _DesktopForumChatPlaceholder(
                            l10n: l10n,
                            isDark: isDark,
                          )
                        : GroupChatPage(
                            key: ValueKey(selected.uuid),
                            group: selected,
                            embedded: true,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _DesktopForumRoomsHeader extends StatelessWidget {
  const _DesktopForumRoomsHeader({
    required this.l10n,
    required this.isDark,
    required this.onRefresh,
    required this.onCreate,
  });

  final AppLocalizations l10n;
  final bool isDark;
  final VoidCallback onRefresh;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark
        ? CbsColors.darkBorder.withValues(alpha: 0.9)
        : CbsColors.creamDark;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.forumRooms,
              style: smallStyle18.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: isDark
                    ? CbsColors.darkTextPrimary
                    : CbsColors.primaryBrown,
              ),
            ),
          ),
          IconButton(
            tooltip: l10n.createGroup,
            onPressed: onCreate,
            icon: Icon(
              Icons.add_rounded,
              color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
            ),
          ),
          IconButton(
            tooltip: l10n.refresh,
            onPressed: onRefresh,
            icon: Icon(
              Icons.refresh_rounded,
              color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopForumRoomTile extends StatelessWidget {
  const _DesktopForumRoomTile({
    required this.group,
    required this.l10n,
    required this.isDark,
    required this.selected,
    required this.onTap,
  });

  final GroupData group;
  final AppLocalizations l10n;
  final bool isDark;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final name = group.name ?? l10n.unnamedGroup;
    final description = (group.description ?? '').trim();
    final selectedBg = isDark
        ? CbsColors.brandGold.withValues(alpha: 0.14)
        : CbsColors.primaryBrown.withValues(alpha: 0.10);
    final selectedBorder = isDark
        ? CbsColors.brandGold.withValues(alpha: 0.65)
        : CbsColors.primaryBrown;
    final idleBg =
        isDark ? CbsColors.darkBg : const Color(0xFFF4EFE6);
    final idleBorder = isDark
        ? CbsColors.darkBorder.withValues(alpha: 0.9)
        : CbsColors.creamDark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? selectedBg : idleBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? selectedBorder : idleBorder,
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: smallStyle18.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: isDark
                            ? CbsColors.darkTextPrimary
                            : CbsColors.primaryBrown,
                      ),
                    ),
                  ),
                  if (group.is_private == true)
                    Icon(
                      Icons.lock_rounded,
                      size: 14,
                      color: isDark
                          ? CbsColors.brandGold
                          : CbsColors.primaryBrown,
                    ),
                ],
              ),
              if (description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: verySmallStyle12.copyWith(
                    color: isDark
                        ? CbsColors.darkTextSecondary
                        : CbsColors.hintColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DesktopForumChatHeader extends StatelessWidget {
  const _DesktopForumChatHeader({
    required this.group,
    required this.l10n,
    required this.isDark,
  });

  final GroupData? group;
  final AppLocalizations l10n;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark
        ? CbsColors.darkBorder.withValues(alpha: 0.9)
        : CbsColors.creamDark;
    final title = group?.name ?? l10n.forumSelectRoom;
    final description = (group?.description ?? '').trim();

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: smallStyle18.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 17,
              color: isDark
                  ? CbsColors.darkTextPrimary
                  : CbsColors.primaryBrown,
            ),
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              description,
              style: verySmallStyle12.copyWith(
                color: isDark
                    ? CbsColors.darkTextSecondary
                    : CbsColors.hintColor,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DesktopForumChatPlaceholder extends StatelessWidget {
  const _DesktopForumChatPlaceholder({
    required this.l10n,
    required this.isDark,
  });

  final AppLocalizations l10n;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          l10n.forumPickRoomHint,
          textAlign: TextAlign.center,
          style: smallStyle18.copyWith(
            fontSize: 14,
            color: isDark ? CbsColors.darkTextSecondary : CbsColors.hintColor,
          ),
        ),
      ),
    );
  }
}

class _DesktopForumEmptyRooms extends StatelessWidget {
  const _DesktopForumEmptyRooms({
    required this.l10n,
    required this.isDark,
    required this.onCreate,
  });

  final AppLocalizations l10n;
  final bool isDark;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            l10n.noGroups,
            textAlign: TextAlign.center,
            style: smallStyle18.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark
                  ? CbsColors.darkTextPrimary
                  : CbsColors.primaryBrown,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.createFirst,
            textAlign: TextAlign.center,
            style: verySmallStyle12.copyWith(
              color: isDark
                  ? CbsColors.darkTextSecondary
                  : CbsColors.hintColor,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(l10n.createGroup),
            style: FilledButton.styleFrom(
              backgroundColor:
                  isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
              foregroundColor:
                  isDark ? CbsColors.brownNight : CbsColors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _ForumHeroBanner extends StatelessWidget {
  const _ForumHeroBanner({required this.l10n, required this.isDark});

  final AppLocalizations l10n;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [CbsColors.darkSurface, CbsColors.darkElevated]
              : [CbsColors.white, CbsColors.sandLight],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? CbsColors.goldDeep.withValues(alpha: 0.45)
              : CbsColors.creamDark,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark
                  ? CbsColors.brandGold.withValues(alpha: 0.15)
                  : CbsColors.primaryBrown.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.forum_rounded,
              color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
            ),
          ),
          gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.forum,
                  style: smallStyle18.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: isDark
                        ? CbsColors.darkTextPrimary
                        : CbsColors.primaryBrown,
                  ),
                ),
                gapH4,
                Text(
                  l10n.createFirst,
                  style: smallStyle18.copyWith(
                    fontSize: 13,
                    height: 1.3,
                    color: isDark
                        ? CbsColors.darkTextSecondary
                        : CbsColors.caramel,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ForumErrorBanner extends StatelessWidget {
  const _ForumErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CbsColors.errorColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: CbsColors.errorColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: CbsColors.errorColor, size: 20),
          gapW8,
          Expanded(
            child: Text(
              message,
              style: smallStyle18.copyWith(
                color: CbsColors.errorColor,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ForumEmptyState extends StatelessWidget {
  const _ForumEmptyState({
    required this.l10n,
    required this.isDark,
    required this.onCreate,
  });

  final AppLocalizations l10n;
  final bool isDark;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: isDark ? CbsColors.darkSurface : CbsColors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? CbsColors.darkBorder : CbsColors.creamDark,
              ),
            ),
            child: Icon(
              Icons.groups_rounded,
              size: 48,
              color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
            ),
          ),
          gapH20,
          Text(
            l10n.noGroups,
            textAlign: TextAlign.center,
            style: smallStyle18.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: isDark
                  ? CbsColors.darkTextPrimary
                  : CbsColors.primaryBrown,
            ),
          ),
          gapH8,
          Text(
            l10n.createFirst,
            textAlign: TextAlign.center,
            style: smallStyle18.copyWith(
              fontSize: 14,
              color: isDark
                  ? CbsColors.darkTextSecondary
                  : CbsColors.hintColor,
            ),
          ),
          gapH24,
          FilledButton.icon(
            onPressed: onCreate,
            icon: const Icon(Icons.add_rounded, size: 20),
            label: Text(l10n.createGroup),
            style: FilledButton.styleFrom(
              backgroundColor:
                  isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
              foregroundColor:
                  isDark ? CbsColors.brownNight : CbsColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _ForumGroupAvatar extends StatelessWidget {
  const _ForumGroupAvatar({
    required this.name,
    required this.isDark,
    this.isPrivate = false,
  });

  final String name;
  final bool isDark;
  final bool isPrivate;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) {
      final s = parts.first;
      return (s.length >= 2 ? s.substring(0, 2) : s).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: isDark ? CbsColors.darkElevated : CbsColors.sandLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? CbsColors.goldDeep.withValues(alpha: 0.5)
                  : CbsColors.creamDark,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            _initials,
            style: smallStyle18.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
            ),
          ),
        ),
        if (isPrivate)
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: isDark ? CbsColors.darkSurface : CbsColors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? CbsColors.darkBorder : CbsColors.creamDark,
                ),
              ),
              child: Icon(
                Icons.lock_rounded,
                size: 12,
                color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
              ),
            ),
          ),
      ],
    );
  }
}

class _GroupCard extends StatefulWidget {
  final GroupData group;
  final SupabaseService? apiService;

  const _GroupCard({
    required this.group,
    this.apiService,
  });

  @override
  State<_GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<_GroupCard> {
  late final SupabaseService _apiService =
      widget.apiService ?? const SupabaseService.testable();
  MessageData? _lastMessage;
  bool _isLoadingLastMessage = false;
  bool _hasVisibleMessages = false;

  @override
  void initState() {
    super.initState();
    _fetchLastMessage();
  }

  Future<void> _fetchLastMessage() async {
    if (widget.group.uuid == null) return;

    setState(() => _isLoadingLastMessage = true);

    try {
      final messages = await _apiService.fetchMessages(widget.group.uuid!);
      if (mounted) {
        final visibleMessages = messages
            .where(
              (m) =>
                  m.is_deleted != true && (m.content ?? '').trim().isNotEmpty,
            )
            .toList();
        visibleMessages.sort((a, b) {
          if (a.timestamp == null || b.timestamp == null) return 0;
          return b.timestamp!.compareTo(a.timestamp!);
        });
        setState(() {
          _hasVisibleMessages = visibleMessages.isNotEmpty;
          _lastMessage =
              visibleMessages.isNotEmpty ? visibleMessages.first : null;
          _isLoadingLastMessage = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingLastMessage = false);
    }
  }

  String _formatTime(AppLocalizations l10n, String? dateString) {
    if (dateString == null) return '';
    try {
      final date = DateTime.parse(dateString).toLocal();
      final now = DateTime.now();
      final difference = now.difference(date);
      final localeName = l10n.locale.toString();

      if (difference.inDays == 0) {
        return DateFormat.Hm(localeName).format(date);
      } else if (difference.inDays == 1) {
        return l10n.timeYesterdayShort;
      } else if (difference.inDays < 7) {
        return l10n.daysAgo(difference.inDays);
      } else {
        return DateFormat.Md(localeName).format(date);
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final groupName = widget.group.name ?? l10n.unnamedGroup;
    final preview = _isLoadingLastMessage
        ? l10n.loading
        : (_hasVisibleMessages
            ? (_lastMessage?.content ?? l10n.noMessage)
            : l10n.noMessage);

    return Material(
      color: isDark ? CbsColors.darkSurface : CbsColors.white,
      elevation: isDark ? 0 : 1,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GroupChatPage(group: widget.group),
            ),
          );
          if (mounted) await _fetchLastMessage();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? CbsColors.darkBorder.withValues(alpha: 0.85)
                  : CbsColors.creamDark,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              _ForumGroupAvatar(
                name: groupName,
                isDark: isDark,
                isPrivate: widget.group.is_private == true,
              ),
              gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            groupName,
                            style: smallStyle18.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: isDark
                                  ? CbsColors.darkTextPrimary
                                  : CbsColors.primaryBrown,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (_lastMessage?.timestamp != null)
                          Text(
                            _formatTime(l10n, _lastMessage!.timestamp),
                            style: verySmallStyle12.copyWith(
                              color: isDark
                                  ? CbsColors.darkTextMetadata
                                  : CbsColors.hintColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                    gapH4,
                    Text(
                      preview,
                      style: smallStyle18.copyWith(
                        fontSize: 13,
                        color: isDark
                            ? CbsColors.darkTextSecondary
                            : CbsColors.caramel,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if ((widget.group.description ?? '').trim().isNotEmpty) ...[
                      gapH4,
                      Text(
                        widget.group.description!.trim(),
                        style: verySmallStyle12.copyWith(
                          color: isDark
                              ? CbsColors.darkTextMetadata
                              : CbsColors.hintColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              gapW4,
              Icon(
                Icons.chevron_right_rounded,
                color: isDark
                    ? CbsColors.darkTextMetadata
                    : CbsColors.hintColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateRoomPage extends StatefulWidget {
  const _CreateRoomPage();

  @override
  State<_CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<_CreateRoomPage> {
  final SupabaseService _apiService = SupabaseService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isPrivate = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration({
    required String label,
    required IconData icon,
    required bool isDark,
    int maxLines = 1,
  }) {
    final fill = isDark ? CbsColors.darkElevated : CbsColors.white;
    final borderColor =
        isDark ? CbsColors.darkBorder : CbsColors.creamDark;
    final labelColor =
        isDark ? CbsColors.brandGold : CbsColors.caramel;

    return InputDecoration(
      labelText: label,
      labelStyle: smallStyle18.copyWith(color: labelColor),
      prefixIcon: Icon(
        icon,
        color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
      ),
      filled: true,
      fillColor: fill,
      alignLabelWithHint: maxLines > 1,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
          width: 1.5,
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final name = _nameController.text.trim();
    final description = _descriptionController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.groupNameRequired)),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final result = await _apiService.createGroup(
        name: name,
        description: description,
        isPrivate: _isPrivate,
      );
      if (!mounted) return;
      if (result['success'] == true) {
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.groupCreateError),
            backgroundColor: CbsColors.errorColor,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.unknownError),
          backgroundColor: CbsColors.errorColor,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? CbsColors.darkBg : CbsColors.brandIvory,
      appBar: AppBar(
        title: Text(
          l10n.createGroup,
          style: smallStyle18.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? CbsColors.darkSurface : CbsColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? CbsColors.goldDeep.withValues(alpha: 0.4)
                      : CbsColors.creamDark,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.groups_rounded,
                    color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
                  ),
                  gapW12,
                  Expanded(
                    child: Text(
                      l10n.createFirst,
                      style: smallStyle18.copyWith(
                        fontSize: 13,
                        height: 1.35,
                        color: isDark
                            ? CbsColors.darkTextSecondary
                            : CbsColors.caramel,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            gapH20,
            TextField(
              controller: _nameController,
              style: smallStyle18.copyWith(
                color: isDark
                    ? CbsColors.darkTextPrimary
                    : CbsColors.primaryDark[800],
              ),
              decoration: _fieldDecoration(
                label: l10n.groupName,
                icon: Icons.title_rounded,
                isDark: isDark,
              ),
            ),
            gapH16,
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              style: smallStyle18.copyWith(
                color: isDark
                    ? CbsColors.darkTextPrimary
                    : CbsColors.primaryDark[800],
              ),
              decoration: _fieldDecoration(
                label: l10n.description,
                icon: Icons.description_outlined,
                isDark: isDark,
                maxLines: 4,
              ),
            ),
            gapH16,
            Material(
              color: isDark ? CbsColors.darkSurface : CbsColors.white,
              borderRadius: BorderRadius.circular(14),
              child: SwitchListTile(
                value: _isPrivate,
                onChanged: (v) => setState(() => _isPrivate = v),
                activeThumbColor:
                    isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
                title: Text(
                  l10n.privateGroup,
                  style: smallStyle18.copyWith(
                    fontSize: 14,
                    color: isDark
                        ? CbsColors.darkTextPrimary
                        : CbsColors.primaryBrown,
                  ),
                ),
                subtitle: Text(
                  l10n.private,
                  style: verySmallStyle12.copyWith(
                    color: isDark
                        ? CbsColors.darkTextSecondary
                        : CbsColors.hintColor,
                  ),
                ),
                secondary: Icon(
                  Icons.lock_outline_rounded,
                  color: isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(
                    color: isDark
                        ? CbsColors.darkBorder
                        : CbsColors.creamDark,
                  ),
                ),
              ),
            ),
            gapH24,
            FilledButton.icon(
              onPressed: _isSubmitting ? null : _submit,
              icon: _isSubmitting
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: isDark
                            ? CbsColors.brownNight
                            : CbsColors.white,
                      ),
                    )
                  : const Icon(Icons.check_rounded),
              label: Text(_isSubmitting ? l10n.loading : l10n.create),
              style: FilledButton.styleFrom(
                backgroundColor:
                    isDark ? CbsColors.brandGold : CbsColors.primaryBrown,
                foregroundColor:
                    isDark ? CbsColors.brownNight : CbsColors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
