import 'package:flutter/material.dart';
import 'package:master_kit/util/platform.dart';
import 'package:ui_kit/adaptive/widget/adaptive.dart';
import 'package:ui_kit/input/dropdown/model/options_list_settings.dart';

class OptionsList<TOption> extends StatefulWidget {
  final OptionsListSettings<TOption> settings;

  const OptionsList({super.key, required this.settings});

  @override
  State<OptionsList<TOption>> createState() => _OptionsListState<TOption>();
}

class _OptionsListState<TOption> extends State<OptionsList<TOption>> {
  final _scrollController = ScrollController();
  OptionsListSettings<TOption> get _settings => widget.settings;

  final firstFocusNode = FocusNode();
  final lastFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    lastFocusNode.addListener(() {
      if (!lastFocusNode.hasFocus && FocusScope.of(context).hasFocus) {
        _scrollController.jumpTo(0);
        // BUG FIX: ListView caches its items. If there's a lot of them, the next focus jumps to the first CACHED item
        // instead of the first item in the ListView
        firstFocusNode.requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayScrollbar = _settings.scrollbarVisible ?? !Adaptive.platform.isMobile;
    return displayScrollbar ? Scrollbar(controller: _scrollController, child: _buildListView()) : _buildListView();
  }

  Widget _buildListView() {
    final optionsAsList = _settings.options.toList();
    return ListView.separated(
      separatorBuilder: _settings.dividerBuilder ?? (_, __) => const SizedBox(),
      padding: EdgeInsets.zero,
      controller: _scrollController,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final option = optionsAsList[index];

        final isFirstOption = index == 0;
        final isLastOption = index == _settings.options.length - 1;
        final lastFocusNodeOrNull = isLastOption ? lastFocusNode : null;

        final isOptionEnabled = _settings.isOptionEnabled?.call(option) ?? true;

        return SizedBox(
          height: _settings.rowHeight,
          child: ListTile(
            // both following properties have to be set to prevent miss-centered list tile content
            minVerticalPadding: 0,
            focusNode: isFirstOption ? firstFocusNode : lastFocusNodeOrNull,
            dense: true,
            title: Padding(
              padding: _settings.paddingForOption ?? EdgeInsets.zero,
              child: _buildOptionPresentation(option, isOptionEnabled),
            ),
            onTap: isOptionEnabled ? () => _settings.onSelected?.call(option) : null,
          ),
        );
      },
      itemCount: optionsAsList.length,
    );
  }

  Widget _buildOptionPresentation(TOption option, bool isOptionEnabled) {
    final theme = Theme.of(context);
    final optionWidgetBuilder = _settings.optionWidgetBuilder;

    if (optionWidgetBuilder != null) {
      return optionWidgetBuilder(context, option);
    }
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        _settings.displayStringForOption?.call(option) ?? option.toString(),
        maxLines: _settings.textWrapMaxLines ?? 2,
        overflow: TextOverflow.ellipsis,
        // TODO(betka): rename deprecated textTheme properties after checking if every project has it defined
        style: theme.textTheme.titleMedium?.copyWith(color: isOptionEnabled ? null : theme.disabledColor),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    firstFocusNode.dispose();
    lastFocusNode.dispose();
    super.dispose();
  }
}
