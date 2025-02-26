// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: type=lint, duplicate_ignore

part of 'travel_time_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$travelTimeHash() => r'b309b731b7ecb63f9896067485571d5e34249361';

/// See also [travelTime].
@ProviderFor(travelTime)
final travelTimeProvider = FutureProvider<TravelTimeTables>.internal(
  travelTime,
  name: r'travelTimeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$travelTimeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TravelTimeRef = FutureProviderRef<TravelTimeTables>;
String _$travelTimeDepthMapHash() =>
    r'baadfe17a963b0f833d36447080933a6b4b6238e';

/// See also [travelTimeDepthMap].
@ProviderFor(travelTimeDepthMap)
final travelTimeDepthMapProvider =
    FutureProvider<Map<int, List<TravelTimeTable>>>.internal(
  travelTimeDepthMap,
  name: r'travelTimeDepthMapProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$travelTimeDepthMapHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef TravelTimeDepthMapRef
    = FutureProviderRef<Map<int, List<TravelTimeTable>>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
