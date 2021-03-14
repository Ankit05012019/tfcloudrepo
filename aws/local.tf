
provider local {}

/*resource "local_file" "testfile"  {
     filename = var.filename
     content = "create using local tf provider testing lifecycyle "
      lifecycle {
        prevent_destroy = true
     }
} */

resource "local_file" "testfiles" {

 for_each = toset(var.test)
 filename = each.value
 content = " testing"
  
}

output "testfile" {

     value = local_file.testfiles
  
}
