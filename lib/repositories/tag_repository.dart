import 'package:recipes/data_mapper.dart';
import 'package:recipes/database.dart';
import 'package:recipes/models/tag.dart';

class TagRepository {
  final AppDatabase database;

  TagRepository({required this.database});

  Future<List<Tag>> getTags() async {
    List<TagData> tagsData = await database.getTags();

    return DataMapper.tagsFromData(tagsData);
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
