import 'package:get_it/get_it.dart';
import 'package:recipes/data_mapper.dart';
import 'package:recipes/database.dart';
import 'package:recipes/models/tag.dart';

class TagRepository {
  AppDatabase database = GetIt.I<AppDatabase>();

  TagRepository();

  Future<List<Tag>> getTags() async {
    List<TagData> dataList = await database.getTags();

    return DataMapper.tagListFromData(dataList);
  }

  Future<List<int>> addTags(List<Tag> tags) async {
    return database.addTags(tags);
  }

  Future<int> insertOrUpdateTag(Tag tag) async {
    return database.insertOrUpdateTag(tag);
  }

  Future<void> addRecipeTags(int recipeId, List<int> tagIds) async {
    return database.addRecipeTags(recipeId, tagIds);
  }

  Future<void> updateRecipeTags(int recipeId, List<int> tagIds) async {
    return database.updateRecipeTags(recipeId, tagIds);
  }
}
