import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/navigation/domain/nav_item.dart";
import "package:kinoapay_app/core/navigation/domain/nav_items.dart";

/// Navigation flottante light, fond blanc, ombre douce, pastille quinoaGold glissante.
class KinoaBottomNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const KinoaBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  State<KinoaBottomNav> createState() => _KinoaBottomNavState();
}

class _KinoaBottomNavState extends State<KinoaBottomNav> {
  final List<GlobalKey> _tabKeys =
      List.generate(NavItems.all.length, (_) => GlobalKey());
  final GlobalKey _stackKey = GlobalKey();

  double _pillLeft = 0;
  double _pillWidth = 44;
  double _pillHeight = 40;
  bool _measured = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _measureTab(widget.currentIndex, animate: false),
    );
  }

  @override
  void didUpdateWidget(KinoaBottomNav old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _measureTab(widget.currentIndex),
      );
    }
  }

  void _measureTab(int index, {bool animate = true}) {
    if (!mounted) return;
    final tabBox =
        _tabKeys[index].currentContext?.findRenderObject() as RenderBox?;
    final stackBox =
        _stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (tabBox == null || stackBox == null) return;

    final offset = tabBox.localToGlobal(Offset.zero, ancestor: stackBox);
    setState(() {
      _pillLeft = offset.dx;
      _pillWidth = tabBox.size.width;
      _pillHeight = tabBox.size.height;
      _measured = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset + 12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: KinoaColors.quinoaDark.withValues(alpha: 0.07),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: KinoaColors.quinoaDark.withValues(alpha: 0.10),
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
          child: Stack(
            key: _stackKey,
            clipBehavior: Clip.hardEdge,
            children: [
              if (_measured)
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  left: _pillLeft,
                  top: 0,
                  width: _pillWidth,
                  height: _pillHeight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: KinoaColors.quinoaGold,
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(NavItems.all.length, (i) {
                  return _NavTab(
                    key: _tabKeys[i],
                    item: NavItems.all[i],
                    isActive: i == widget.currentIndex,
                    onTap: () => widget.onTabChanged(i),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  final NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTab({
    super.key,
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 14 : 11,
          vertical: 10,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? item.activeIcon : item.icon,
              size: 20,
              color: isActive ? Colors.white : KinoaColors.quinoaWarmGray,
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                item.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
