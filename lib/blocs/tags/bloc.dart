import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipes/blocs/tags/events.dart';
import 'package:recipes/blocs/tags/state.dart';
import 'package:recipes/repositories/tag_repository.dart';

class TagsBloc extends Bloc<TagsEvent, TagsState> {
  final TagRepository tagRepository;

  TagsBloc({required this.tagRepository}) : super(LoadingTagsState()) {
    on<GetTags>(
      (event, emit) async {
        try {
          emit(LoadedTagsState(tags: await tagRepository.getTags()));
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

          // go through the provided tags: if it doesn't have an id,
          // insert it into the database

          for (int i = 0; i < tags.length; i++) {
            int id = await tagRepository.insertOrUpdateTag(tags[i]);

            tags[i] = tags[i].copyWith(id: id);
          }

          // get all tag ids to add them to the recipe

          final tagIds = tags.map((t) => t.id!).toList();

          // this deletes recipe's tags and adds the updated ones
          await tagRepository.updateRecipeTags(recipeId, tagIds);

          // add the new tags to the state
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
