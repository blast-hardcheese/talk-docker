{% set docker_version = "0.11.1" %}
{% set docker_hash = "md5=3fc7e007d6637afa11e1632294d7f882" %}
{% set docker_tcp_socket = "tcp://127.0.0.1:4243" %}
{% set docker_unix_socket = "unix:///var/run/docker.sock" %}

docker.io:
  pkg:
    - installed
  file.managed:
    - name: /usr/bin/docker.io
    - source: https://get.docker.io/builds/Linux/x86_64/docker-{{ docker_version }}
    - source_hash: {{ docker_hash }}
    - mode: 755
  service.running:
    - enable: True
    - watch:
      - file: docker.io
      - file: /etc/default/docker.io

/etc/default/docker.io:
  file.managed:
    - contents: |
        # Docker Upstart and SysVinit configuration file

        # Customize location of Docker binary (especially for development testing).
        #DOCKER="/usr/local/bin/docker"

        # Use DOCKER_OPTS to modify the daemon startup options.
        #DOCKER_OPTS="-dns 8.8.8.8 -dns 8.8.4.4"
        # Let's bind both a TCP socket and a Unix socket
        DOCKER_OPTS="--host {{ docker_tcp_socket }} --host {{ docker_unix_socket }}"

        # If you need Docker to use an HTTP proxy, it can also be specified here.
        #export http_proxy="http://127.0.0.1:3128/"

        # This is also a handy place to tweak where Docker's temporary files go.
        #export TMPDIR="/mnt/bigdrive/docker-tmp"

/usr/bin/docker:
  file.managed:
    - contents: |
        export DOCKER_HOST={{ docker_tcp_socket }}
        docker.io "$@"
    - mode: 0755
    - require:
      - pkg: docker.io
