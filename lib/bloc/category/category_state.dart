part of 'category_bloc.dart';

sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategoryListResponse extends CategoryState {
  final Either<String, List<CategoryModel>> categoryList;
  CategoryListResponse(this.categoryList);
}
