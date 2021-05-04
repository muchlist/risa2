import '../json_models/option/location_type.dart';
import '../json_models/option/stock_category.dart';
import 'json_parsers.dart';

class LocationTypeParser extends JsonParser<OptLocationType>
    with ObjectDecoder<OptLocationType> {
  @override
  Future<OptLocationType> parseFromJson(String json) async {
    final decoded = decodeJsonObject(json);
    return OptLocationType.fromJson(decoded);
  }
}

class StockCategoryParser extends JsonParser<OptStockCategory>
    with ObjectDecoder<OptStockCategory> {
  @override
  Future<OptStockCategory> parseFromJson(String json) async {
    final decoded = decodeJsonObject(json);
    return OptStockCategory.fromJson(decoded);
  }
}
