function validateForm(){
  validate_flag = true;
  var post_title = document.forms["post_form"]["title"].value.trim();
  var post_content = document.forms["post_form"]["content"].value.trim();
  post_length = post_title.length;
  content_length = post_content.length;
  if ((post_title == null || post_title == "")  && (post_content == null || post_content == "")){
    alert("Title and content of post is missing..!");
    validate_flag = false;
    return false;
  }
  else if (( post_title != null || post_title != "") && (post_content == null || post_content == "")){
    alert("Content of post is missing..!");
    validate_flag = false;
    document.getElementById("post_form_id").reset();
    return false;
  }
  else if (( post_content != null || post_content != "") && (post_title == null || post_title == "")){
    alert("Title of post is missing..!");
    validate_flag = false;
    document.getElementById("post_form_id").reset();
    return false;
  }
  if (post_length > 255){
    alert("You have exceed the word limit..!(max. 255)");
    validate_flag = false;
    document.getElementById("post_form_id").reset();
    return false;
  }
  if (content_length > 1000){
    alert("You have exceed the word limit..!(max. 1000)");
    validate_flag = false;
    document.getElementById("post_form_id").reset();
    return false;
  }
  if(validate_flag == true)
  {
    return true;
  }
}

function validateShow(){
  validate_flag = true;
  var comment = document.forms["comment_form"]["comment"].value.trim();
  comment_length = comment.length;
  if(comment == null || comment == ""){
    alert("Comment field is missing.!");
    validate_flag = false;
    return false;
  }
  if(comment_length > 255){
    alert("You have exceed the word limit of comment.(max. 255)");
    validate_flag = false;
    return false;
  }
  if(validate_flag == true){
    return true;
  }
}

function promptConfirm(){
  var result = confirm("Are you sure?");
  if(result == false)
    return false;
  else
    return true;
}