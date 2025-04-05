import 'package:drift/drift.dart';
import 'package:recipes/database/database.dart';
import 'package:recipes/models/tag.dart';

part 'tags_dao.g.dart';

@DriftAccessor(tables: [Tags, RecipeTags])
class TagsDao extends DatabaseAccessor<AppDatabase> with _$TagsDaoMixin {
  TagsDao(super.db);

  Future<List<TagData>> getRecipeTags(int recipeId) async {
    final query = select(recipeTags).join([
      innerJoin(tags, tags.id.equalsExp(recipeTags.tagId)),
    ])
      ..where(recipeTags.recipeId.equals(recipeId));

    List<TypedResult> rows = await query.get();

    return rows.map((row) {
      return row.readTable(tags);
    }).toList();
  }

  // Get all tags.
  Future<List<TagData>> getTags() async {
    return select(tags).get();
  }

  // Add a list of tags and return their ids.
  // Can't use batch because it returns void.
  Future<List<int>> addTags(List<Tag> tagList) async {
    List<int> ids = [];

    for (var tag in tagList) {
      int id = await into(tags).insert(tag.toCompanion());

      ids.add(id);
    }

    return ids;
  }

  // Add or update tag.
  Future<int> insertOrUpdateTag(Tag tag) async {
    if (tag.id == null) {
      return await into(tags).insert(
        tag.toCompanion(),
      );
    } else {
      await (update(tags)..where((t) => t.id.equals(tag.id!)))
          .write(tag.toCompanion());
      return tag.id!;
    }
  }

  // Add tags to a recipe.
  Future<void> addRecipeTags(int recipeId, List<int> tagIds) async {
    await batch((batch) {
      batch.insertAll(
        recipeTags,
        tagIds
            .map((tagId) =>
                RecipeTagsCompanion.insert(recipeId: recipeId, tagId: tagId))
            .toList(),
      );
    });
  }

  // Update a recipe's tags (delete old ones, add new ones and remove orphaned ones).
  // TODO: refactor
  Future<void> updateRecipeTags(int recipeId, List<int> tagIds) async {
    await transaction(() async {
      await deleteRecipeTags(recipeId);
      await addRecipeTags(recipeId, tagIds);
      await deleteOrphanedTags();
    });
  }

  // Delete recipe's tags.
  Future<void> deleteRecipeTags(int recipeId) async {
    await transaction(() async {
      await (delete(recipeTags)..where((t) => t.recipeId.equals(recipeId)))
          .go();
    });
  }

  // Remove orphaned tags.
  Future<void> deleteOrphanedTags() async {
    await customStatement('''
        DELETE FROM tags 
        WHERE id NOT IN (
            SELECT DISTINCT tag_id FROM recipe_tags
        )
      ''');
  }
}
