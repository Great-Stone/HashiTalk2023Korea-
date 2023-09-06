job "spring-boot-hello" {
  datacenters = ["hashitalks-kr"] # 사용할 데이터 센터 이름으로 수정
  namespace   = "dev"

  type = "service"

  constraint {
    attribute = "${attr.driver.java.version}"
    operator  = ">"
    value     = "17.0"
  }

  group "run-spring-boot" {

    network {
      port "boot" {
        static = 8080
      }
    }

    task "java" {

      driver = "java"

      config {
        jar_path    = "local/hashitalks-0.0.1-SNAPSHOT.jar"
        jvm_options = ["-Xmx2048m", "-Xms256m"]
      }

      env {
        PORT  = "${NOMAD_PORT_boot}"
        COLOR = "skyblue"
      }

      artifact {
        source      = "https://github.com/Great-Stone/images/raw/master/build/hashitalks-0.0.1-SNAPSHOT.jar"
        destination = "local/"
      }

      resources {
        cpu        = 500
        memory     = 256
        memory_max = 2048
      }

      service {
        provider = "nomad"

        name = "spring-boot"
        port = "boot"

        check {
          type     = "http"
          path     = "/hello"
          interval = "2s"
          timeout  = "2s"
        }
      }
    }
  }
}
