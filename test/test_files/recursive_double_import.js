alert("Hey this is an alert");
$(document).ready(doStuff);
$('a.important_tag').click(function() {
  if(doStuff()) {
    $(this).attr("href", "www.google.com/");
  }
});
function doStuff(){
  var number = 9 * 12 - 19 + 2;
  if(number == 200) {
    return true;
  } else {
    return false;
  }
}
alert("Hey this is an alert");
$(document).ready(doStuff);
$('a.important_tag').click(function() {
  if(doStuff()) {
    $(this).attr("href", "www.google.com/");
  }
});
function doStuff(){
  var number = 9 * 12 - 19 + 2;
  if(number == 200) {
    return true;
  } else {
    return false;
  }
}