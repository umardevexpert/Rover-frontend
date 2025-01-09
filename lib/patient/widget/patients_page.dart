import 'package:flutter/material.dart';
import 'package:intersperse/intersperse.dart';
import 'package:intl/intl.dart';
import 'package:rover/common/model/tab_definition.dart';
import 'package:rover/common/service/ioc_container.dart';
import 'package:rover/common/theme/extension/app_theme.dart';
import 'package:rover/common/theme/shared_ui_constants.dart';
import 'package:rover/common/widget/page_template.dart';
import 'package:rover/common/widget/page_title_with_description.dart';
import 'package:rover/common/widget/primary_button.dart';
import 'package:rover/common/widget/tabs_toggle.dart';
import 'package:rover/patient/model/patients_appointment.dart';
import 'package:rover/patient/model/patients_table_metadata.dart';
import 'package:rover/patient/service/patients_page_controller.dart';
import 'package:rover/patient/widget/connection_failed_body.dart';
import 'package:rover/patient/widget/counter_card.dart';
import 'package:rover/patient/widget/filter_settings_persistent_header.dart';
import 'package:rover/patient/widget/patients_table.dart';
import 'package:rover/patient/widget/rover_card_slice.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:ui_kit/stream/widget/multi_stream_builder3.dart';
import 'package:ui_kit/util/assets.dart';

class PatientsPage extends StatefulWidget {
  PatientsPage({super.key});

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  final _controller = get<PatientsPageController>();
  final _scrollController = ScrollController();
  var _refreshing = false;

  @override
  void initState() {
    super.initState();
    _controller.refreshTableControllers();
    _controller.refreshPatientsData();
    _controller.startRefreshTimer();

    /// This part of code is for saving & restoring the scroll position on patients page (each table has it's own)
    _scrollController.addListener(() => _controller.scrollOffset = _scrollController.offset);
    _controller.sortingAndScrollingStream.listen((tableMetadata) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          setState(() => _scrollController.jumpTo(tableMetadata.scrollOffset));
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.stopRefreshTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      padding: EdgeInsets.zero,
      body: MultiStreamBuilder3(
        stream1: _controller.activeTabIndexStream,
        stream2: _controller.sortingAndScrollingStream,
        stream3: _controller.patientsDataStream,
        waitingForDataWidgetBuilder: (_) => _buildPatientsPage(-1, null, null, false),
        errorBuilder: (_, __) => _buildPatientsPage(-1, null, null, true),
        builder: (_, activeTabIndex, tableMetadata, tableData) =>
            _buildPatientsPage(activeTabIndex, tableMetadata, tableData, false),
      ),
    );
  }

  Widget _buildPatientsPage(
    int activeTabIndex,
    PatientsTableMetadata? tableMetadata,
    List<PatientsAppointment>? tableData,
    bool hasError,
  ) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _buildTitleAndDate(),
        SliverPadding(padding: PAGE_HORIZONTAL_PADDING, sliver: SliverToBoxAdapter(child: _buildInformationCardsRow())),
        const SliverToBoxAdapter(child: LARGER_GAP),
        SliverPersistentHeader(delegate: FilterSettingsPersistentHeader(), pinned: true),
        _buildMainCardContent(tableMetadata, activeTabIndex, tableData, hasError),
      ],
    );
  }

  Widget _buildTitleAndDate() {
    return SliverPinnedHeader(
      child: PageTitleWithDescription(
        title: 'Patients',
        description: 'Explore and collect all information about your patients',
        chipText: DateFormat(LONG_DATE).format(DateTime.now()),
      ),
    );
  }

  Widget _buildMainCardContent(
    PatientsTableMetadata? metadata,
    int activeTabIndex,
    List<PatientsAppointment>? tableData,
    bool hasError,
  ) {
    final appTheme = AppTheme.of(context);
    return MultiSliver(children: [
      SliverPinnedHeader(
        child: Container(
          color: appTheme?.colorScheme.grey100,
          padding: const EdgeInsets.symmetric(horizontal: 68.0),
          child: RoverCardSlice(
            first: true,
            padding: const EdgeInsets.only(
              top: STANDARD_UI_GAP,
              left: LARGE_UI_GAP,
              right: LARGE_UI_GAP,
              bottom: LARGE_UI_GAP,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_buildTableSwitcher(activeTabIndex, hasError), _buildRefreshButton()],
            ),
          ),
        ),
      ),
      if (hasError)
        _buildMainCardTableReplacement(ConnectionFailedBody())
      else if (metadata != null && tableData != null)
        PatientsTable(metadata: metadata, tableData: tableData, showStatusColumn: activeTabIndex == 0)
      else
        _buildMainCardTableReplacement(Center(child: CircularProgressIndicator())),
      SliverPinnedHeader(
        child: Container(
          color: appTheme?.colorScheme.grey100,
          padding: const EdgeInsets.symmetric(horizontal: 68.0),
          child: RoverCardSlice(last: true, height: LARGE_UI_GAP),
        ),
      ),
      const SliverToBoxAdapter(child: LARGER_GAP),
    ]);
  }

  Widget _buildInformationCardsRow() {
    // TODO(matej): Implement with correct data
    return Row(
      children: [
        (
          title: 'Appointments today',
          value: '3/4',
          icon: Assets.svgImage('icon/counters/today_appointments'),
        ),
        (
          title: 'Monthly appointments',
          value: '54',
          icon: Assets.svgImage('icon/counters/monthly_appointments'),
        ),
        (
          title: 'Active patients',
          value: '129',
          icon: Assets.svgImage('icon/counters/active_patients'),
        ),
        (
          title: 'Presentations',
          value: '12',
          icon: Assets.svgImage('icon/counters/presentations'),
        ),
      ]
          .map<Widget>(
            (counter) => CounterCard(title: counter.title, value: counter.value, icon: counter.icon),
          )
          .intersperse(STANDARD_GAP)
          .toList(),
    );
  }

  Widget _buildTableSwitcher(int activeTabIndex, bool hasError) {
    return TabsToggle(
      activeIndex: activeTabIndex,
      onIndexChanged: hasError ? (_) {} : (index) => _controller.activeTabIndex = index,
      tabs: const [
        TabDefinition(label: 'Today’s appointments'),
        TabDefinition(label: 'All patients'),
      ],
    );
  }

  Widget _buildRefreshButton() {
    return PrimaryButton(
      onPressed: () async {
        setState(() => _refreshing = true);
        await _controller.refreshPatientsData();
        setState(() => _refreshing = false);
      },
      size: PrimaryButtonSize.large,
      enabled: !_refreshing,
      prefixIcon: _refreshing ? SizedBox.square(dimension: 15, child: CircularProgressIndicator(strokeWidth: 3)) : null,
      child: Text('Refresh'),
    );
  }

  Widget _buildMainCardTableReplacement(Widget child) {
    return SliverPinnedHeader(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 68.0),
        child: RoverCardSlice(
          child: Center(
            child: SizedBox(
              width: 526,
              height: 400,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
