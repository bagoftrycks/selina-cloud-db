# Selina Cloud DB

A VM to host multiple docker containers about DB thing.
It's not a ready-production thing,
more for a testing / developing environment.

The VM contains docker-compose config for:
- Cassandra Cluster
- Redis Cluster (from mechanist-redis)
- RethinkDB Cluster

You can grab directly the docker-compose file.
You are not force to use the VirtualBox + Vagrant structure.

I use it like that cause I put the whole thing into my own dedicated server
which container also other VM (Virtualbox + Vagrant).