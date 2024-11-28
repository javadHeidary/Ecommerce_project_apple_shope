import 'package:shop/data/model/variant_model.dart';
import 'package:shop/data/model/variant_type_model.dart';

class ProductVariantModel {
  VariantTypeModel? variantType;
  List<VariantModel>? variantList;

  ProductVariantModel(this.variantType, this.variantList);
}
