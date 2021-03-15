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

resource "local_file" "testfiles2" {

 for_each = toset(var.test)
 filename = each.value
 content = " testing"
  
}

output "testfile2" {

     value = local_file.testfiles
  
}
