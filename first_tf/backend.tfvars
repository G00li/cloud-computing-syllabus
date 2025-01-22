cluster={
    name = "etic-cluster"
    node = 2
}

app = {
  name = "value"
  containerName = "nginx"
  replicas = 3
  image = "nginx:alpine"
  port = 80
}

cluster = {
  
}