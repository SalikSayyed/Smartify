//     /*/(<([(\/)tag>]+)>)*/
// --selects <tag> , </tag>
// /<style.*[^>]*?\/style>/   remove style
//(<div>)(<p>.*?<\/p>)(<\/div>)    -->remove div tags inclusing  p tags magic wand grps 1,3
// --can be replaced with blank
// String newstr=str.replaceAll(RegExp(r' [\w]+=\"[\w \" : \\ ! % & * ( ) # # ]+"'),'');
//
String MagicWand(passedString) {
  String htmlactual_magic = passedString
      .replaceAll(
          RegExp(r' [\w - ;]+=\"[\w \" : \\ - ;! % & * ; . / ( ) # # ]+\"'), '')
      .replaceAll(RegExp(r'<[?].*?>|<meta .*?>'), '')
      .replaceAll(RegExp(r'<style(.|\s|\n)*>(.|\n)*?<\/style>'), '')
      .replaceAll(
          RegExp(
              r'(<[\/?\w = " " ^ @ $*()! $ % # & - + \  \s]+?>)(?<!<p >|<p>)(?<!<\/p>)(?<!<html>|<html >)(?<!<\/html>)(?<!<div>|<div >)(?<!<\/div>)(?<!<\/head>)(?<!<head>|<head >)(?<!<title>|<title >)(?<!<\/title>)(?<!<body>|<body >)(?<!<\/body>)(?<!<img>|<img >)(?<!<\/img>)'),
          '')
      .replaceAllMapped(RegExp(r'([(])+(.*?)([)])'), (match) {
    return '"${match.group(1)}"';
  }).replaceAllMapped(RegExp(r'(<div>)(<p>.*?</p>)(</div>)'), (match) {
    return '${match.group(2)}';
  }).replaceAllMapped(RegExp(r"(<div>([\w\s.\n]+)</div>)"), (match) {
    return '<p>${match.group(2)}</p>';
  });
  //print("before magic 1:");
  // String newstrr = htmlactual.replaceAll(
  //     RegExp(r' [\w - ;]+=\"[\w \" : \\ - ;! % & * ; . / ( ) # # ]+\"'), '');
  // String newnewstrr = newstrr.replaceAll(RegExp(r'<[?].*?>|<meta .*?>'), '');
  // //print("before magic 2: " + newnewstrr);
  // String new_str =
  //     newnewstrr.replaceAll(RegExp(r'<style(.|\s|\n)*>(.|\n)*?<\/style>'), '');
  // //print("before magic 3: " + new_str);

  // String newnewnewstrr = new_str.replaceAll(
  //     RegExp(
  //         r'(<[\/?\w = " " ^ @ $*()! $ % # & - + \  \s]+?>)(?<!<p >|<p>)(?<!<\/p>)(?<!<html>|<html >)(?<!<\/html>)(?<!<div>|<div >)(?<!<\/div>)(?<!<\/head>)(?<!<head>|<head >)(?<!<title>|<title >)(?<!<\/title>)(?<!<body>|<body >)(?<!<\/body>)(?<!<img>|<img >)(?<!<\/img>)'),
  //     '');
  // String new4str =
  //     newnewnewstrr.replaceAllMapped(RegExp(r'([(])+(.*?)([)])'), (match) {
  //   return '"${match.group(1)}"';
  // });
  // String new_new_str =
  //     new4str.replaceAllMapped(RegExp(r'(<div>)(<p>.*?</p>)(</div>)'), (match) {
  //   return '${match.group(2)}';
  // });
  // String new_new_new_str = new_new_str
  //     .replaceAllMapped(RegExp(r"(<div>([\w\s.\n]+)</div>)"), (match) {
  //   return '<p>${match.group(2)}</p>';
  // });

  print("*|* --> \n" + htmlactual_magic);
  return htmlactual_magic;
}

/*
newstrr

*/
