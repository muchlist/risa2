import '../json_models/option/computer_option.dart';
import '../json_models/option/location_division.dart';

import '../json_models/option/location_type.dart';
import '../json_models/option/stock_category.dart';
import 'json_parsers.dart';

class LocationTypeParser extends JsonParser<OptLocationType>
    with ObjectDecoder<OptLocationType> {
  @override
  Future<OptLocationType> parseFromJson(String json) async {
    final Map<String, dynamic> decoded = decodeJsonObject(json);
    return OptLocationType.fromJson(decoded);
  }
}

class StockCategoryParser extends JsonParser<OptStockCategory>
    with ObjectDecoder<OptStockCategory> {
  @override
  Future<OptStockCategory> parseFromJson(String json) async {
    final Map<String, dynamic> decoded = decodeJsonObject(json);
    return OptStockCategory.fromJson(decoded);
  }
}

class ComputerOptParser extends JsonParser<OptComputerType>
    with ObjectDecoder<OptComputerType> {
  @override
  Future<OptComputerType> parseFromJson(String json) async {
    final Map<String, dynamic> decoded = decodeJsonObject(json);
    return OptComputerType.fromJson(decoded);
  }
}

class LocationDivisionParser extends JsonParser<OptLocationDivison>
    with ObjectDecoder<OptLocationDivison> {
  @override
  Future<OptLocationDivison> parseFromJson(String json) async {
    final Map<String, dynamic> decoded = decodeJsonObject(json);
    return OptLocationDivison.fromJson(decoded);
  }
}
