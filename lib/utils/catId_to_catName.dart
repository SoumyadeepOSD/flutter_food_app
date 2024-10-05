import 'package:foodapp/models/categories_model.dart';
import 'package:foodapp/services/api/api_service.dart';

ApiService service = ApiService();

Future<List<String>> categoryIdToCategoryName({required List catIds}) async {
  try {
    print(catIds);
    List<String> categoryNames = await Future.wait(
      catIds.map((e) async {
        CategoryModel? categoryData =
            await service.fetchCategories(e.toString());
        return categoryData!.name;
      }).toList(),
    );
    return categoryNames;
  } catch (e) {
    print('Error: $e');
    return [];
  }
}
