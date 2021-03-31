import 'package:flutter_vs_code/pages/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductAdd extends StatefulWidget {
  @override
  _ProductAddState createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _purchase = TextEditingController();
  final TextEditingController _selling = TextEditingController();
  final TextEditingController _qty = TextEditingController();
  bool _isLoading = false;

  final scaffoldMessengerKey = GlobalKey<ScaffoldState>();
  // final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  FocusNode purchaseNode = FocusNode();
  FocusNode sellingNode = FocusNode();
  FocusNode qtyNode = FocusNode();
  
  void submit(BuildContext context) {
    //KITA CEK, JIKA VALUENYA MASIH FALSE, MAKA AKAN PROSES CALL API AKAN DIJALANKAN
    if (!_isLoading) {
      //SET VALUE LOADING JADI TRUE, DAN TEMPATKAN DI DALAM SETSTATE UNTUK MEMBERITAHUKAN PADA WIDGET BAHWA TERJADI PERUBAHAN STATE
      setState(() {
        _isLoading = true;
      });
      
      //MEMANGGIL FUNGSI YANG SUDAH DIDEFINISIKAN DI PROVIDER
      //DENGAN MENGIRIMKAN VALUE DATA NAME, SALARY DAN AGE
      Provider.of<ProductProvider>(context, listen: false)
          .storeProduct(_name.text, _purchase.text, _selling.text, _qty.text)
          .then((res) {
        //JIKA TRUE
        if (res) {
          //MAKA REDIRECT KE HALAMAN MENAMPILKAN DATA EMPLOYEE
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Product()), (route) => false);
        } else {
          //TAMPILKAN ALERT
          var snackbar = SnackBar(content: Text('Ops, Error. Hubungi Admin'),);
          // snackbarKey.currentState.ScaffoldMessenger.showSnackBar(snackbar);
          // scaffoldMessengerKey.currentState.showSnackBar(snackbar);
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
      // key: snackbarKey,
      key: scaffoldMessengerKey,
      appBar: AppBar(
        title: Text('Add Product'),
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
              //JIKA TOMBOL SUBMIT PADA KEYBOARD DITEKAN
              onSubmitted: (_) {
                //MAKA FOCUSNYA AKAN DIPINDAHKAN PADA FORM INPUT SELANJUTNYA
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