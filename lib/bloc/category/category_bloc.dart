import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:shop/data/model/category_model.dart';
import 'package:shop/data/repositories/categoray_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final ICategorayRepository _categorayRepository;

  CategoryBloc(this._categorayRepository) : super(CategoryInitial()) {
    on<CategoryInitRequest>(
      (event, emit) => _loadCategoryRequest(event, emit),
    );
  }

  Future<void> _loadCategoryRequest(
      CategoryInitRequest event, Emitter<CategoryState> emit) async {
    emit(
      CategoryLoading(),
    );

    final Either<String, List<CategoryModel>> categoryList =
        await _categorayRepository.getCategorayList();

    emit(
      CategoryListResponse(categoryList),
    );
  }
}
