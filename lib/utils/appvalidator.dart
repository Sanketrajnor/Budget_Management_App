class AppValidator {
    //Valid Email
  String? validateEmail(value){
    if(value!.isEmpty) {
      return 'Please enter an email';
    }
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if(!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
  //Password
  String? validatePassword(value){
    if(value!.isEmpty) {
      return 'Please enter a password';
    }
    return null;
  }
  //Valid Phone Number 
 String? validatePhoneNum(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a phone number';
  }
  RegExp phoneRegExp = RegExp(r'^\d{10}$');
  if (value.length != 10 || !phoneRegExp.hasMatch(value)) {
    return 'Please enter a 10-digit valid phone number';
  }
  return null;
}
  //Valid Username
String? validateUsername(String? value) {
  if (value!.isEmpty) {
    return 'Please enter your username';
  }
  return null;
}
String? isEmptyCheck(String? value) {
  if (value!.isEmpty) {
    return 'Please fill details';
  }
  return null;
}

}