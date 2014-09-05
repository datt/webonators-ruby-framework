function validateForm(){
    var post_title = document.forms["post_form"]["title"].value;
    var post_content = document.forms["post_form"]["content"].value;
    post_length = post_title.length;
    post_content = post_content.length;
    if (post_title == null || post_content == null ) {
        alert("Title and Content of post is missing..!");
        return false;
    }
    else if ( post_title != null || post_title != "") && (post_content == null || post_content == "")
    {
      alert ("Content of post is missing..!");
      return false;
    }
    else if ( post_content! = null || post_content!= "") && (post_title == null || post_title == "")
    {
      alert ("Title of post is missing..!")
      return false;
    }
    if (post_title > 255)
    {
      alert("You have exceed the word limit for title(max. 255)!");
      return false;
    }
    if (post_content > 1000)
    {
      alert("You have exceed the word limit for content(mox. 1000)..!");
      return false;
    }
}

