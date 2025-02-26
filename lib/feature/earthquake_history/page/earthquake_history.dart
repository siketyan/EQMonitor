import 'package:eqmonitor/core/provider/config/earthquake_history/earthquake_history_config_provider.dart';
import 'package:eqmonitor/core/router/router.dart';
import 'package:eqmonitor/feature/earthquake_history/component/earthquake_history_tile_widget.dart';
import 'package:eqmonitor/feature/earthquake_history/model/state/earthquake_history_item.dart';
import 'package:eqmonitor/feature/earthquake_history/viewmodel/earthquake_history_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EarthquakeHistoryPage extends HookConsumerWidget {
  const EarthquakeHistoryPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(earthquakeHistoryViewModelProvider);
    final scrollController = PrimaryScrollController.of(context);
    useEffect(
      () {
        WidgetsBinding.instance.endOfFrame.then(
          (_) async {
            scrollController.addListener(
              () => ref
                  .read(earthquakeHistoryViewModelProvider.notifier)
                  .onScrollPositionChanged(
                    scrollController,
                  ),
            );
            // 初回読み込みを行う
            await ref
                .read(earthquakeHistoryViewModelProvider.notifier)
                .fetchIfNeeded();
          },
        );
        return null;
      },
      [],
    );
    final body = PrimaryScrollController(
      controller: scrollController,
      child: CustomScrollView(
        primary: true,
        slivers: [
          SliverAppBar.medium(
            title: const Text('地震の履歴'),
            actions: [
              IconButton(
                onPressed: () => context.push(
                  const EarthquakeHistoryConfigRoute().location,
                ),
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          state?.when(
                data: (data) {
                  return EarthquakeHistoryListView(
                    data: data,
                  );
                },
                error: (error, stackTrace) {
                  // dataがある場合にはそれを表示
                  if (state.hasValue) {
                    final data = state.value!;
                    return EarthquakeHistoryListView(
                      data: data,
                    );
                  }
                  return SliverFillRemaining(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '地震履歴の取得中にエラーが発生しました。',
                        ),
                        FilledButton.tonal(
                          onPressed: ref
                              .read(earthquakeHistoryViewModelProvider.notifier)
                              .fetch,
                          child: const Text('再読み込み'),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const SliverFillRemaining(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '地震履歴を取得中です。',
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ],
                  ),
                ),
              ) ??
              const CircularProgressIndicator.adaptive(),
        ],
      ),
    );
    return Scaffold(
      body: RefreshIndicator.adaptive(
        onRefresh: ref.read(earthquakeHistoryViewModelProvider.notifier).fetch,
        edgeOffset: 112,
        child: body,
      ),
    );
  }
}

class EarthquakeHistoryListView extends ConsumerWidget {
  const EarthquakeHistoryListView({
    super.key,
    required this.data,
  });

  final List<EarthquakeHistoryItem> data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shouldShowBackgroundColor = ref.watch(
      earthquakeHistoryConfigProvider
          .select((value) => value.list.isFillBackground),
    );
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: data.length + 1,
        (context, index) {
          if (index == data.length) {
            return const _ListBottomWidget();
          }
          final item = data[index];
          return EarthquakeHistoryTileWidget(
            item: item,
            onTap: (p0) => context.push(
              EarthquakeHistoryDetailsRoute(p0.eventId).location,
            ),
            showBackgroundColor: shouldShowBackgroundColor,
          );
        },
      ),
    );
  }
}

class _ListBottomWidget extends ConsumerWidget {
  const _ListBottomWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(earthquakeHistoryViewModelProvider);
    const loading = Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: CircularProgressIndicator.adaptive(),
      ),
    );
    return state?.map(
          data: (data) {
            if (state.isLoading) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            }
            return const SizedBox.shrink();
          },
          error: (error) {
            if (state.isLoading) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 40,
                horizontal: 10,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '地震履歴の取得中にエラーが発生しました。',
                  ),
                  // 再読み込み
                  FilledButton.tonal(
                    onPressed: () => ref
                        .read(earthquakeHistoryViewModelProvider.notifier)
                        .fetch(),
                    child: const Text('再読み込み'),
                  ),
                  Text(
                    error.error.toString(),
                  ),
                ],
              ),
            );
          },
          loading: (data) => loading,
        ) ??
        loading;
  }
}
