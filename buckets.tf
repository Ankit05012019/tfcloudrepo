module "s3buckets" {

    source = "../modules/s3bucket"
    bucket_name = var.bucket_name


  
}