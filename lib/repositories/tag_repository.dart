import 'package:recipes/data_mapper.dart';
import 'package:recipes/database/database.dart';
import 'package:recipes/models/tag.dart';

class TagRepository {
  final AppDatabase database;

  TagRepository({required this.database});

  Future<List<Tag>> getTags() async {
    List<TagData> tagsData = await database.tagsDao.getTags();

    return DataMapper.tagsFromData(tagsData);
  }

  Future<List<int>> addTags(List<Tag> tags) async {
    return database.tagsDao.addTags(tags);
  }

  Future<int> insertOrUpdateTag(Tag tag) async {
    return database.tagsDao.insertOrUpdateTag(tag);
  }

  Future<void> addRecipeTags(int recipeId, List<int> tagIds) async {
    return database.tagsDao.addRecipeTags(recipeId, tagIds);
  }

  Future<void> updateRecipeTags(int recipeId, List<int> tagIds) async {
    return database.tagsDao.updateRecipeTags(recipeId, tagIds);
  }
}
