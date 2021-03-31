import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_vs_code/providers/product_provider.dart';
import './product_add.dart';
import './product_edit.dart';

class Product extends StatelessWidget {
  //DUMMY DATA YANG AKAN DITAMPILKAN SEBELUM MELAKUKAN HIT KE API
  //ADAPUN FORMAT DATANYA MENGIKUTI STRUKTUR YANG SUDAH DITETAPKAN PADA PRODUCT MODEL
  final data = [
    ProductModel(
      id: "1",
      productName: "Bolpen AE7",
      productPurchase: "2000",
      productSelling: "5000",
      productQty: "100",
    ),
    ProductModel(
      id: "2",
      productName: "Kertas Sinar Dunia A4 70gr",
      productPurchase: "75000",
      productSelling: "100000",
      productQty: "65",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product CRUD'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        child: Text('+'),
        onPressed: () {
          //BUAT NAVIGASI UNTUK BERPINDAH KE HALAMAN PRODUCTADD
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ProductAdd()));
        },
      ),
      body: RefreshIndicator(
        //ADAPUN FUNGSI YANG DIJALANKAN ADALAH getProduct() DARI PRODUCT_PROVIDER
        onRefresh: () =>
            Provider.of<ProductProvider>(context, listen: false).getProduct(),
        color: Colors.red,
        child: Container(
          margin: EdgeInsets.all(10),
          //KETIKA PAGE INI DIAKSES MAKA AKAN MEMINTA DATA KE API
          child: FutureBuilder(
            //DENGAN MENJALANKAN FUNGSI YANG SAMA
            future: Provider.of<ProductProvider>(context, listen: false)
                .getProduct(),
            builder: (context, snapshot) {
              //JIKA PROSES REQUEST MASIH BERLANGSUNG
              if (snapshot.connectionState == ConnectionState.waiting) {
                //MAKA KITA TAMPILKAN INDIKATOR LOADING
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              //SELAIN ITU KITA RENDER ATAU TAMPILKAN DATANYA
              //ADAPUN UNTUK MENGAMBIL DATA DARI STATE DI PROVIDER
              //MAKA KITA GUNAKAN CONSUMER
              return Consumer<ProductProvider>(
                builder: (context, data, _) {
                  //KEMUDIAN LOOPING DATANYA DENGNA LISTVIEW BUILDER
                  return ListView.builder(
                    //ADAPUN DATA YANG DIGUNAKAN ADALAH REAL DATA DARI GETTER dataEmployee
                    itemCount: data.dataProduct.length,
                    itemBuilder: (context, i) {
                      //WRAP DENGAN INKWELL UNTUK MENGGUNAKAN ATTRIBUTE ONTAPNYA
                      return InkWell(
                        onTap: () {
                          //DIMANA KETIKA DI-TAP MAKA AKAN DIARAHKAN
                          Navigator.of(context).push(
                            //KE CLASS EMPLOYEEEDIT DENGAN MENGIRIMKAN ID EMPLOYEE
                            MaterialPageRoute(
                              builder: (context) => ProductEdit(id: data.dataProduct[i].id,),
                            ),
                          );
                        },
                        child: Dismissible(
                          key: UniqueKey(), //GENERATE UNIQUE KEY UTK MASING-MASING ITEM
                          direction: DismissDirection.endToStart, //ATUR ARAH DISMISSNYA
                          //BUAT KONFIRMASI KETIKA USER INGIN MENGHAPUS DATA
                          confirmDismiss: (DismissDirection direction) async {
                            //TAMPILKAN DIALOG KONFIRMASI
                            final bool res = await showDialog(context: context, builder: (BuildContext context) {
                              //DENGAN MENGGUNAKAN ALERT DIALOG
                              return AlertDialog(
                                title: Text('Konfirmasi Delete'),
                                content: Text('Apakah anda yakin?'),
                                actions: <Widget>[
                                  //KITA SET DUA BUAH TOMBOL UNTUK HAPUS DAN CANCEL DENGAN VALUE BOOLEAN
                                  TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text('HAPUS'),),
                                  TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text('BATALKAN'),)
                                ],
                              );
                            });
                            return res;
                          },
                          onDismissed: (value) {
                            //KETIKA VALUENYA TRUE, MAKA FUNGSI INI AKAN DIJALANKAN, UNTUK MENGHAPUS DATA
                            Provider.of<ProductProvider>(context, listen: false).deleteProduct(data.dataProduct[i].id).then((res) {
                              if (res) {
                                var snackbar = SnackBar(content: Text('Product Berhasil Dihapus'),);
                                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                              } else {
                                //TAMPILKAN ALERT
                                var snackbar = SnackBar(content: Text('Ops, Error. Hubungi Admin'),);
                                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                              }
                            });
                          },
                          child: Card(
                            elevation: 8,
                            child: ListTile(
                              title: Text(
                              //DAN DATA YANG DITAMPILKAN JG DIAMBIL DARI GETTER DATAEMPLOYEE
                              //SESUAI INDEX YANG SEDANG DILOOPING
                                data.dataProduct[i].productName,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              subtitle:
                                  Text('Harga Beli: ${data.dataProduct[i].productPurchase}'),
                              trailing:
                                  Text("Rp. ${data.dataProduct[i].productSelling}"),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}