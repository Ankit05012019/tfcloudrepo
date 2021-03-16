terraform {
  backend "remote" {
    organization = "scaleworx"

    workspaces {
      name = "tfcloudrepo"
    }
  }
}


provider local {}

/*resource "local_file" "testfile"  {
     filename = var.filename
     content = "create using local tf provider testing lifecycyle "
      lifecycle {
        prevent_destroy = true
     }
} */

resource "local_file" "this" {

 for_each = toset(var.test)
 filename = each.value
 content = " testing"
  
}

output "testfile" {

     value = local_file.testfiles
  
}
