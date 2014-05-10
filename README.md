Docker Talk
===========

Here are the commands I use for this talk.

Setting up the machine using srv/salt/docker.sls currently assumes Debian, and should be readable enough that you can piece together what it does even without running salt.

    # Before the talk, ensure we have all the deps required for Apache2
    docker build .talk_helpers/apache2-deps

    # Build first server
    docker build -t server1 server1
    docker run -d -P --name test_server1 server1
    docker port test_server1 80
    #   This should return something like: 0.0.0.0:49155

    # Check to see if our first server is actually running, you should see server1's index.html
    curl http://localhost:49155/

    # Build apache2 image
    docker build -t apache2 apache2

    # Build second and third images
    docker build -t server2 server2
    docker build -t server3 server3

    # Start up nginx-proxy, based on jwilder's fantastic docker-gen (https://github.com/jwilder/docker-gen)
    docker run -d -p 8080:80 -v /var/run/docker.sock:/tmp/docker.sock -t jwilder/nginx-proxy

    # Test proxy
    curl http://localhost:8080/
    # This should time out, since the nginx proxy doesn't have any hosts to connect to.

    # We need to restart test_server1, so let's kill it and remove the container (not the image).
    # This will allow us to bind to that name in the next group of commands.
    docker kill test_server1 && docker rm test_server1

    # Start all servers. Let's just call our vhost "localhost" so we don't need to mess with DNS.
    docker run -e VIRTUAL_HOST=localhost -d -P --name test_server1 server1
    docker run -e VIRTUAL_HOST=localhost -d -P --name test_server2 server2
    docker run -e VIRTUAL_HOST=localhost -d -P --name test_server3 server3

    # Test proxy again, as many times as you want.
    # Each request should go to a different server, in order.
    curl http://localhost:8080/
