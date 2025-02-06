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
  }
}
