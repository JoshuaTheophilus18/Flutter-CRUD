import 'package:flutter_vs_code/pages/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductEdit extends StatefulWidget {
  final String id; //INISIASI VARIABLE ID;
  ProductEdit({this.id}); //BUAT CONSTRUCT UNTUK MEMINTA DATA ID

  @override
  _ProductEditState createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _purchase = TextEditingController();
  final TextEditingController _selling = TextEditingController();
  final TextEditingController _qty = TextEditingController();
  bool _isLoading = false;

  final snackbarKey = GlobalKey<ScaffoldState>();

  FocusNode purchaseNode = FocusNode();
  FocusNode sellingNode = FocusNode();
  FocusNode qtyNode = FocusNode();

  //KETIKA CLASS INI AKAN DI-RENDER, MAKA AKAN MENJALANKAN FUNGSI BERIKUT
  @override
  void initState() {
    //BUAT DELAY
    Future.delayed(Duration.zero, () {
      //MENJALANKAN FUNGSI FINDEMPLOYEE UNTUK MENCARI DATA EMPLOYEE BERDASARKAN IDNYA
      //CARA MENGAKSES ID DARI CONSTRUCTOR PADA STATEFUL WIDGET ADALAH 
     //WIDGET DOT DAN DIIKUTI DENGAN VARIABLE YANG INGIN DIAKSES
      Provider.of<ProductProvider>(context, listen: false).findProduct(widget.id).then((response) {
        //JIKA DITEMUKAN, MAKA DATA TERUS KITA MASUKKAN KE DALAM VARIABLE CONTROLLER UNTUK TEKS FIELD
        _name.text = response.productName;
        _purchase.text = response.productPurchase;
        _selling.text = response.productSelling;
        _qty.text = response.productQty;
      });
    });
    super.initState();
  }

  void submit(BuildContext context) {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      //ADAPUN UNTUK PROSES UPDATE, JALANKAN FUNGSI UPDATEEMPLOYEE() DENGNA MENGIRIMKAN DATA YANG SAMA KETIKA ADD DATA, HANYA SAJA DITAMBAHKAN DENGAN ID PEGAWAI
      Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(widget.id, _name.text, _purchase.text, _selling.text, _qty.text)
          .then((res) {
        if (res) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Product()), (route) => false);
        } else {
          var snackbar = SnackBar(content: Text('Ops, Error. Hubungi Admin'),);
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: snackbarKey,
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          TextButton(
            child: _isLoading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
            onPressed: () => submit(context),
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: _name,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.pinkAccent,
                  ),
                ),
                hintText: 'Nama Product',
              ),
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(purchaseNode);
              },
            ),
            TextField(
              controller: _purchase,
              focusNode: purchaseNode,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.pinkAccent,
                  ),
                ),
                hintText: 'Harga Beli',
              ),
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(sellingNode);
              },
            ),
            TextField(
              controller: _selling,
              focusNode: sellingNode,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.pinkAccent,
                  ),
                ),
                hintText: 'Harga Jual',
              ),
              onSubmitted: (_) {
                FocusScope.of(context).requestFocus(qtyNode);
              },
            ),
            TextField(
              controller: _qty,
              focusNode: qtyNode,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.pinkAccent,
                  ),
                ),
                hintText: 'Stok Barang',
              ),
            ),
          ],
        ),
      ),
    );
  }
}