import 'package:flutter/material.dart';

class CustomInputData extends StatefulWidget {
  const CustomInputData({Key? key,
    required this.userInfo, // 이메일 : userEmail, 비번: userPassWord
    required this.labelText, // 이메일 : 이메일, 비번: 비밀번호
    required this.placeholderText,
    // 이메일 : 이메일을 입력해 주세요.
    // 비번 : 비밀번호를 입력해 주세요.

    required this.inputType,
    // 이메일 : TextInputType.emailAddress
    // 비번 : TextInputType.text

    required this.isObscureText, // 이메일: false, 비번: true

  }) : super(key: key);

  final TextEditingController userInfo;
  final String labelText;
  final String placeholderText;
  final TextInputType inputType;
  final bool isObscureText;

  @override
  State<CustomInputData> createState() => _CustomInputDataState();
}

class _CustomInputDataState extends State<CustomInputData> {
  @override
  Widget build(BuildContext context) {

    TextEditingController userInfo = widget.userInfo;
    String labelText = widget.labelText;
    String placeholderText = widget.placeholderText;
    TextInputType inputType = widget.inputType;
    bool isObscureText = widget.isObscureText;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black,
            style: BorderStyle.solid,
            width: 2
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.symmetric(horizontal: 30),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * ( 10 / 392.7),
          ),
          Flexible(
            child: TextField(
              style: TextStyle(fontSize: 16, color: Color(0xff262626),
                  fontWeight: FontWeight.bold),
              controller: userInfo, // 유저가 입력한 비밀번호
              decoration: InputDecoration(
                label: Text(labelText, style: TextStyle(color: Color(0xff262626)),),
                border: InputBorder.none,
                hintText: placeholderText,
              ),
              keyboardType: inputType,
              obscureText: isObscureText,
            ),
          )
        ],
      ),
    );
  }
}
