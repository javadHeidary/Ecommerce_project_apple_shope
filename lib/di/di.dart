import 'dart:async';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/bloc/authentication/authentication_bloc.dart';
import 'package:shop/bloc/basket/basket_bloc.dart';
import 'package:shop/bloc/category/category_bloc.dart';
import 'package:shop/bloc/home/home_bloc.dart';
import 'package:shop/bloc/product_comment/product_comment_bloc.dart';
import 'package:shop/bloc/product_detial/product_detial_bloc.dart';
import 'package:shop/bloc/product_list/product_list_bloc.dart';
import 'package:shop/data/datasources/authentication_datasource.dart';
import 'package:shop/data/datasources/banner_datasource.dart';
import 'package:shop/data/datasources/basket_datasource.dart';
import 'package:shop/data/datasources/categoray_datasource.dart';
import 'package:shop/data/datasources/category_product_datasource.dart';
import 'package:shop/data/datasources/product_comment_datasource.dart';
import 'package:shop/data/datasources/product_datasource.dart';
import 'package:shop/data/datasources/product_detial_datasource.dart';
import 'package:shop/data/model/hive_model/basket_item_model.dart';
import 'package:shop/data/repositories/authentication_repository.dart';
import 'package:shop/data/repositories/banner_repository.dart';
import 'package:shop/data/repositories/basket_repository.dart';
import 'package:shop/data/repositories/categoray_repository.dart';
import 'package:shop/data/repositories/category_product_repository.dart';
import 'package:shop/data/repositories/product_comment_repositorty.dart';
import 'package:shop/data/repositories/product_detial_repository.dart';
import 'package:shop/data/repositories/product_repository.dart';
import 'package:shop/util/dio_provider.dart';

var locator = GetIt.instance;
Future<void> serviceLocator() async {
  await _initUtil();
  _initDataSource();
  _initRepository();
  _initBloc();
}

void _initDataSource() {
  locator.registerSingleton<ICategorayDatasource>(
    CategorayRemote(
      locator.get<Dio>(),
    ),
  );
  locator.registerSingleton<IBannerDatasource>(
    BannerRemote(
      locator.get<Dio>(),
    ),
  );
  locator.registerSingleton<IProductDetialDatasource>(
    ProductDetialRemote(
      locator.get<Dio>(),
    ),
  );
  locator.registerSingleton<IProductDatasource>(
    ProductRemote(
      locator.get<Dio>(),
    ),
  );
  locator.registerSingleton<ICategoryByProductDatasource>(
    CategoryByProductRemote(
      locator.get<Dio>(),
    ),
  );
  locator.registerSingleton<IProductCommentDatasource>(
    ProductCommentRemote(
      locator.get<Dio>(),
    ),
  );

  locator.registerFactory<IBasketDatasource>(
    () => BasketLocal(
      locator.get<Box<BasketItemModel>>(),
    ),
  );
  locator.registerSingleton<IAuthenticationDatasource>(
    AuthenticationRemote(),
  );
}

void _initRepository() {
  locator.registerSingleton<ICategorayRepository>(
    CategorayRepository(
      locator.get<ICategorayDatasource>(),
    ),
  );
  locator.registerSingleton<IBannerRepository>(
    BannerRepository(
      locator.get<IBannerDatasource>(),
    ),
  );
  locator.registerSingleton<IProductDetialRepository>(
    ProductDetialRepository(
      locator.get<IProductDetialDatasource>(),
    ),
  );
  locator.registerSingleton<IProductRepository>(
    ProductRepository(
      locator.get<IProductDatasource>(),
    ),
  );

  locator.registerSingleton<ICategoryByProductRepository>(
    CategoryByProductRepository(
      locator.get<ICategoryByProductDatasource>(),
    ),
  );

  locator.registerSingleton<IProductCommentRepositorty>(
    ProductCommentRepositorty(
      locator.get<IProductCommentDatasource>(),
    ),
  );
  locator.registerFactory<IBasketRepository>(
    () => BasketRepositoty(
      locator.get<IBasketDatasource>(),
    ),
  );
  locator.registerSingleton<IAuthenticationRepository>(
    AuthenticationRepository(
      locator.get<IAuthenticationDatasource>(),
    ),
  );
}

Future<void> _initUtil() async {
  locator.registerSingleton<Box<BasketItemModel>>(
    Hive.box<BasketItemModel>('BasketBox'),
  );
  locator.registerSingleton<SharedPreferences>(
    await SharedPreferences.getInstance(),
  );
  locator.registerSingleton<Dio>(
    DioProvider.creatDio(),
  );
}

void _initBloc() {
  locator.registerFactory<AuthBloc>(
    () => AuthBloc(
      locator.get<IAuthenticationRepository>(),
    ),
  );
  locator.registerFactory<HomeBloc>(
    () => HomeBloc(
      locator.get<IBannerRepository>(),
      locator.get<ICategorayRepository>(),
      locator.get<IProductRepository>(),
    ),
  );
  locator.registerFactory<ProductDetialBloc>(
    () => ProductDetialBloc(
      locator.get<IProductDetialRepository>(),
      locator.get<IBasketRepository>(),
    ),
  );
  locator.registerSingleton<BasketBloc>(
    BasketBloc(
      locator.get<IBasketRepository>(),
    ),
  );
  locator.registerFactory<ProductListBloc>(
    () => ProductListBloc(
      locator.get<ICategoryByProductRepository>(),
    ),
  );
  locator.registerFactory<ProductCommentBloc>(
    () => ProductCommentBloc(
      locator.get<IProductCommentRepositorty>(),
    ),
  );
  locator.registerFactory<CategoryBloc>(
    () => CategoryBloc(
      locator.get<ICategorayRepository>(),
    ),
  );
}
