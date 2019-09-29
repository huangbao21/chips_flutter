import 'package:chips_flutter/utils.dart';
import 'package:flutter/material.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  TextEditingController _contentController = TextEditingController();
  TextEditingController _contactController = TextEditingController();

  FocusNode _focusNode = FocusNode();

  GlobalKey _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _contentController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return platformNavigator(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: BackButtonIcon(),
            color: Colors.black,
            onPressed: () {
              platformNavigator(context);
            },
          ),
          title: Text('意见反馈', style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: _buildPage(),
      ),
    );
  }

  Widget _buildPage() {
    return GestureDetector(
      onTap: (){
        _focusNode.unfocus();
      },
      child: Container(
        color: Colors.grey[200],
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(children: [
                        Text(
                          '问题和意见',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          '*',
                          style: TextStyle(color: Colors.red),
                        )
                      ]),
                    ),
                    TextFormField(
                      autovalidate: true,
                      focusNode: _focusNode,
                      style: TextStyle(fontSize: 16),
                      controller: _contentController,
                      maxLength: 500,
                      maxLines: 8,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Colors.grey[200],
                        hintStyle: 
                            TextStyle(color: Colors.grey[400], fontSize: 16),
                        hintText: "填写10个字以上的问题描述或意见建议，以便我们更好地提供帮助",
                      ),
                      validator: (String v) {
                        return v.trim().length > 0 ? null : '请输入内容';
                      },
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(children: [
                        Text(
                          '联系方式',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(
                          ' (选填)',
                          style:
                              TextStyle(color: Colors.grey[400], fontSize: 13),
                        )
                      ]),
                    ),
                    TextFormField(
                      style: TextStyle(fontSize: 16),
                      controller: _contactController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderSide: BorderSide.none),
                        filled: true,
                        contentPadding: EdgeInsets.all(13),
                        fillColor: Colors.grey[200],
                        hintStyle:
                            TextStyle(color: Colors.grey[400], fontSize: 16),
                        hintText: "填写手机或微信等，方便我们与你联系",
                      ),
                    )
                  ],
                ),
              ),
              DefaultTextStyle(
                style: TextStyle(
                  color: Colors.grey[400],
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('薯条官方QQ群:  660579747'),
                      Text('加入薯条玩家群，你可以get到更多小伙伴')
                    ],
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () async {
                    if ((_formKey.currentState as FormState).validate()) {
                      var res = await Utils.requestHttp(
                          url: '/option_feed',
                          data: {
                            'contact': _contactController.text,
                            'advice': _contentController.text
                          },
                          context: context,
                          method: 'post',
                          beforeLoading: true);
                      if (res != null) {
                        String cmd;
                        cmd = await Utils.showCommonDialog(
                            ok: () {
                              Navigator.of(context).pop("pop");
                            },
                            context: context,
                            title: '提交成功',
                            content: '感谢您的建议与问题，我们将持续优化产品，给您带来最佳的用户体验');
                        if (cmd == 'pop') {
                          platformNavigator(context);
                        }
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(vertical: 15, horizontal: 24),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: _contentController.text.trim().length > 0
                                ? [
                                    Color.fromRGBO(247, 203, 28, 1),
                                    Color.fromRGBO(255, 167, 51, 1)
                                  ]
                                : [Colors.grey, Colors.grey])),
                    child: Text(
                      '提交',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
