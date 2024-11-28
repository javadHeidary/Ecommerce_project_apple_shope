import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:shop/data/model/comment_model.dart';
import 'package:shop/data/repositories/product_comment_repositorty.dart';

part 'product_comment_event.dart';
part 'product_comment_state.dart';

class ProductCommentBloc
    extends Bloc<ProductCommentEvent, ProductCommentState> {
  final IProductCommentRepositorty _productCommentRepositorty;

  ProductCommentBloc(this._productCommentRepositorty)
      : super(ProductCommentLoading()) {
    on<ProductInitCommentListRequest>(_onInitCommentListRequest);
    on<ProductCommentPostRequest>(_onPostCommentRequest);
    on<ProductCommentListRequest>(_onCommentListRequest);
  }

  Future<void> _onInitCommentListRequest(
    ProductInitCommentListRequest event,
    Emitter<ProductCommentState> emit,
  ) async {
    await _loadComments(event.productId, emit);
  }

  Future<void> _onPostCommentRequest(
    ProductCommentPostRequest event,
    Emitter<ProductCommentState> emit,
  ) async {
    emit(ProductCommentLoading());
    final Either<String, String> postResponse =
        await _productCommentRepositorty.postProductComment(
      event.productId,
      event.comment,
    );
    emit(ProductCommentPostResponse(postResponse));
    await _loadComments(event.productId, emit);
  }

  Future<void> _onCommentListRequest(
    ProductCommentListRequest event,
    Emitter<ProductCommentState> emit,
  ) async {
    await _loadComments(event.productId, emit);
  }

  Future<void> _loadComments(
      String productId, Emitter<ProductCommentState> emit) async {
    final Either<String, List<CommentModel>> productCommentList =
        await _productCommentRepositorty.getProductCommentList(productId);
    emit(ProductCommentListResponse(productCommentList));
  }
}
