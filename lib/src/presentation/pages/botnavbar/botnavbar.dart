import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../data/bloc/authentication/authentication_bloc.dart';
import '../../utils/constant/constant.dart';
import 'icon_navbar.dart';

class BotNavBar extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const BotNavBar({required this.navigationShell, super.key});

  @override
  State<BotNavBar> createState() => _BotNavBarState();
}

class _BotNavBarState extends State<BotNavBar> {
  int _currentIndexUser = 0;
  int _currentIndexAdmin = 0;
  int _currentIndexSuperAdmin = 0;

  void _goToBranchUser(int index) {
    widget.navigationShell.goBranch(index,
        initialLocation: index == widget.navigationShell.currentIndex);
  }

  void _goToBranchAdmin(int index) {
    widget.navigationShell.goBranch(index,
        initialLocation: index == widget.navigationShell.currentIndex);
  }

  void _goToBranchSuperAdmin(int index) {
    widget.navigationShell.goBranch(index,
        initialLocation: index == widget.navigationShell.currentIndex);
  }

  final List<BottomNavigationBarItem> _itemBotNavBarUser = [
    const BottomNavigationBarItem(
      icon: IconNavBar(
        iconPath: homeIcon,
        color: Colors.transparent,
      ),
      activeIcon: IconNavBar(
        iconPath: homeActiveIcon,
        color: Colors.blueAccent,
      ),
      label: "Home",
    ),
    const BottomNavigationBarItem(
      icon: IconNavBar(
        iconPath: buildingIcon,
        color: Colors.transparent,
      ),
      activeIcon: IconNavBar(
        iconPath: buildingActiveIcon,
        color: Colors.blueAccent,
      ),
      label: "Gedung",
    ),
    const BottomNavigationBarItem(
      icon: IconNavBar(
        iconPath: reservationIcon,
        color: Colors.transparent,
      ),
      activeIcon: IconNavBar(
        iconPath: reservationActiveIcon,
        color: Colors.blueAccent,
      ),
      label: "Reservasi",
    ),
    const BottomNavigationBarItem(
      icon: IconNavBar(
        iconPath: historyIcon,
        color: Colors.transparent,
      ),
      activeIcon: IconNavBar(
        iconPath: historyActiveIcon,
        color: Colors.blueAccent,
      ),
      label: "Riwayat",
    ),
    const BottomNavigationBarItem(
      icon: IconNavBar(
        iconPath: profileIcon,
        color: Colors.transparent,
      ),
      activeIcon: IconNavBar(
        iconPath: profileActiveIcon,
        color: Colors.blueAccent,
      ),
      label: "Saya",
    ),
  ];

  final List<BottomNavigationBarItem> _iconBotNavBarAdmin = [
    const BottomNavigationBarItem(
      icon: IconNavBar(
        iconPath: homeIcon,
        color: Colors.transparent,
      ),
      activeIcon: IconNavBar(
        iconPath: homeActiveIcon,
        color: Colors.blueAccent,
      ),
      label: "Home",
    ),
    const BottomNavigationBarItem(
      icon: IconNavBar(
        iconPath: buildingIcon,
        color: Colors.transparent,
      ),
      activeIcon: IconNavBar(
        iconPath: buildingActiveIcon,
        color: Colors.blueAccent,
      ),
      label: "Gedung",
    ),
    const BottomNavigationBarItem(
      icon: IconNavBar(
        iconPath: historyIcon,
        color: Colors.transparent,
      ),
      activeIcon: IconNavBar(
        iconPath: historyActiveIcon,
        color: Colors.blueAccent,
      ),
      label: "Laporan",
    ),
    const BottomNavigationBarItem(
      icon: IconNavBar(
        iconPath: profileIcon,
        color: Colors.transparent,
      ),
      activeIcon: IconNavBar(
        iconPath: profileActiveIcon,
        color: Colors.blueAccent,
      ),
      label: "Saya",
    ),
  ];

  final List<BottomNavigationBarItem> _iconBotNavBarSuperAdmin = [
    const BottomNavigationBarItem(
      icon: IconNavBar(
        iconPath: homeIcon,
        color: Colors.transparent,
      ),
      activeIcon: IconNavBar(
        iconPath: homeActiveIcon,
        color: Colors.blueAccent,
      ),
      label: "Home",
    ),
    const BottomNavigationBarItem(
      icon: IconNavBar(
        iconPath: profileIcon,
        color: Colors.transparent,
      ),
      activeIcon: IconNavBar(
        iconPath: profileActiveIcon,
        color: Colors.blueAccent,
      ),
      label: "Saya",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final BottomNavigationBar botNavBarUser = BottomNavigationBar(
      iconSize: 22,
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndexUser,
      onTap: (index) {
        setState(() {
          _currentIndexUser = index;
        });
        _goToBranchUser(_currentIndexUser);
      },
      items: _itemBotNavBarUser,
    );

    final BottomNavigationBar botNavBarAdmin = BottomNavigationBar(
      iconSize: 22,
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndexAdmin,
      onTap: (index) {
        setState(() {
          _currentIndexAdmin = index;
        });
        _goToBranchAdmin(_currentIndexAdmin);
      },
      items: _iconBotNavBarAdmin,
    );

    final BottomNavigationBar botNavBarSuperAdmin = BottomNavigationBar(
      iconSize: 22,
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndexSuperAdmin,
      onTap: (index) {
        setState(() {
          _currentIndexSuperAdmin = index;
        });
        _goToBranchSuperAdmin(_currentIndexSuperAdmin);
      },
      items: _iconBotNavBarSuperAdmin,
    );

    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is IsSuperAdmin) {
          return Scaffold(
            body: SizedBox(
              child: widget.navigationShell,
            ),
            bottomNavigationBar: botNavBarSuperAdmin,
          );
        } else if (state is IsAdmin) {
          return Scaffold(
            body: SizedBox(
              child: widget.navigationShell,
            ),
            bottomNavigationBar: botNavBarAdmin,
          );
        }
        if (state is IsUser) {
          return Scaffold(
            body: SizedBox(
              child: widget.navigationShell,
            ),
            bottomNavigationBar: botNavBarUser,
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
