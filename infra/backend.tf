terraform {
  backend "gcs" { 
    bucket  = "n3rd-tf-state"
    credentials = "./serviceAccountKey.json"
  }
}