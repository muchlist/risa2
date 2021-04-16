import '../json_models/option/location_type.dart';

import 'json_parsers.dart';

class LocationTypeParser extends JsonParser<OptLocationType>
    with ObjectDecoder<OptLocationType> {
  @override
  Future<OptLocationType> parseFromJson(String json) async {
    final decoded = decodeJsonObject(json);
    return OptLocationType.fromJson(decoded);
  }
}
