import 'package:flutter/material.dart';
import 'package:flutter_lovers/app/sohbet_page.dart';
import 'package:flutter_lovers/model/user.dart';
import 'package:flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatefulWidget {
  @override
  _KullanicilarPageState createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> {
  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanicilar"),
      ),
      body: FutureBuilder<List<User>>(
          future: _userModel.getAllUser(),
          builder: (context, sonuc) {
            if (sonuc.hasData) {
              var tumKullanicilar = sonuc.data;

              if (tumKullanicilar.length - 1 > 0) {
                return RefreshIndicator(
                  onRefresh: _kullanicilarListesiniGuncelle,
                  child: ListView.builder(
                    itemCount: tumKullanicilar.length,
                    itemBuilder: (context, index) {
                      var oankiUser = sonuc.data[index];
                      if (oankiUser.userID != _userModel.user.userID) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                builder: (context) => SohbetPage(
                                  currentUser: _userModel.user,
                                  sohbetEdilenUser: oankiUser,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(oankiUser.userName),
                            subtitle: Text(oankiUser.email),
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey.withAlpha(40),
                              backgroundImage:
                                  NetworkImage(oankiUser.profilURL),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                );
              } else {
                return RefreshIndicator(
                  onRefresh: _kullanicilarListesiniGuncelle,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.supervised_user_circle,
                              color: Theme.of(context).primaryColor,
                              size: 120,
                            ),
                            Text(
                              "Henüz Kullanıcı Yok",
                              style: TextStyle(fontSize: 36),
                            )
                          ],
                        ),
                      ),
                      height: MediaQuery.of(context).size.height - 150,
                    ),
                  ),
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Future<Null> _kullanicilarListesiniGuncelle() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));

    return null;
  }
}
