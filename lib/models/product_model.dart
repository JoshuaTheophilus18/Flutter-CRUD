class ProductModel {
  String id;
  String productName;
  String productPurchase;
  String productSelling;
  String productQty;

  //BUAT CONSTRUCTOR AGAR KETIKA CLASS INI DILOAD, MAKA DATA YANG DIMINTA HARUS DIPASSING SESUAI TIPE DATA YANG DITETAPKAN
  ProductModel({
    this.id,
    this.productName,
    this.productPurchase,
    this.productSelling,
    this.productQty
  });
  
  //FUNGSI INI UNTUK MENGUBAH FORMAT DATA DARI JSON KE FORMAT YANG SESUAI DENGAN Product MODEL
  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'],
    productName: json['product_name'],
    productPurchase: json['product_purchase'],
    productSelling: json['product_selling'],
    productQty: json['product_qty']
  );
}