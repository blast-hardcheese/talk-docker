{% set docker_version = "0.11.1" %}
{% set docker_hash = "md5=3fc7e007d6637afa11e1632294d7f882" %}

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
