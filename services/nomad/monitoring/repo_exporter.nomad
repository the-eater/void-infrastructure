job "repo-exporter" {
  type = "service"
  namespace = "monitoring"
  datacenters = ["VOID"]

  group "exporter" {
    network {
      mode = "bridge"
      port "metrics" {
        to = 1234
        static = 9213
      }
    }

    service {
      port = "metrics"
      tags = ["traefik.enable=true", "traefik.http.routers.repo-exporter-exporter.tls=true"]
      check {
        type = "http"
        port = "metrics"
        path = "/"
        address_mode = "host"
        interval = "30s"
        timeout = "2s"
      }
    }

    task "exporter" {
      driver = "docker"

      config {
        image = "ghcr.io/void-linux/repo-exporter:v0.0.5"
      }
    }
  }
}
