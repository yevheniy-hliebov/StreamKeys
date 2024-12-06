import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:streamkeys/common/theme/colors.dart';
import 'package:streamkeys/common/widgets/settings_button.dart';
import 'package:streamkeys/windows/providers/browse_provider.dart';
import 'package:streamkeys/windows/providers/touch_deck_provider.dart';
import 'package:streamkeys/windows/screens/keyboard_deck.dart';
import 'package:streamkeys/windows/screens/touch_deck.dart';
import 'package:streamkeys/windows/widgets/device_name_and_ip.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TouchDeckProvider()),
          ChangeNotifierProvider(create: (context) => BrowseProvider()),
        ],
        child: TabBarView(
          controller: _tabController,
          children: const [
            TouchDeck(),
            KeyboardDeck(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      flexibleSpace: _buildTabBar(),
      centerTitle: true,
      title: const DeviceNameAndIp(),
      actions: const [SettingsButton()],
      backgroundColor: SColors.of(context).surface,
      shape: Border(
        bottom: BorderSide(
          color: SColors.of(context).outlineVariant,
          width: 4,
        ),
      ),
    );
  }

  Column _buildTabBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Touch Deck'),
              Tab(text: 'Keyboard Deck'),
            ],
          ),
        ),
      ],
    );
  }
}
