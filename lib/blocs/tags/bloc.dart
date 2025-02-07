import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/blocs/tags/events.dart';
import 'package:recipes/blocs/tags/state.dart';
import 'package:recipes/database.dart';

class TagsBloc extends Bloc<TagsEvent, TagsState> {
  final DatabaseClient databaseClient;

  TagsBloc({required this.databaseClient}) : super(LoadingTagsState()) {
    on<GetTags>(
      (event, emit) async {
        try {
          emit(LoadedTagsState(tags: await databaseClient.getTags()));
        } catch (error) {
          emit(ErrorLoadingTagsState());
        }
      },
    );
    on<AddRecipeTags>((event, emit) async {
      try {
        final tags = event.tags;
        final recipeId = event.recipeId;

        if (state is LoadedTagsState) {
          final currentState = state as LoadedTagsState;

          for (int i = 0; i < tags.length; i++) {
            if (tags[i].id == null) {
              final id = await databaseClient.insertTag(tags[i]);
              tags[i] = tags[i].copyWith(id: id);
            }
          }

          final tagIds = tags.map((t) => t.id!).toList();

          await databaseClient.insertRecipeTags(recipeId, tagIds);

          final newTags = tags.where((tag) {
            return !currentState.tags.any((t) => t.id == tag.id);
          }).toList();

          emit(LoadedTagsState(tags: [...currentState.tags, ...newTags]));
        }
      } catch (error) {
        emit(ErrorLoadingTagsState());
      }
    });
  }
}
