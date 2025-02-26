import 'package:eqapi_types/model/components/region_intensity.dart';
import 'package:eqapi_types/model/telegram_v3.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'intensity.freezed.dart';
part 'intensity.g.dart';

@freezed
class Intensity with _$Intensity {
  const factory Intensity({
    required JmaIntensity maxInt,
    @Default(null) JmaLgIntensity? maxLgInt,
    @Default(null) LgType? lgCategory,
    required List<RegionIntensity> prefectures,
    required List<RegionIntensity> regions,
    required List<RegionIntensity>? cities,
    required List<RegionIntensity>? stations,
  }) = _Intensity;

  factory Intensity.fromJson(Map<String, dynamic> json) =>
      _$IntensityFromJson(json);
}
