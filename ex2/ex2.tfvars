namespaces = [ "dev", "qa", "prod" ]

app = {
  containerName = "app"
  image = "nginx:alpine"
  name = "app"
  port = 80
  replicas = {
    dev = 1
    qa = 2
    prod = 3
  }
}