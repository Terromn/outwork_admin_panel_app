class NewSaleModel {
  static const String id = 'id';
  static const String name = 'name';
  static const String date = 'date';
  static const String package = 'package';
  static const String price = "price";
  static const String discountPercentage = "discountPercentage";
  static const String paymentForm = "paymentForm";

  

  static List<String> getFields() => [id, name, date, package, price, discountPercentage, paymentForm];
}