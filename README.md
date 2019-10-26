### Get started

For 90% of users, just copy-paste this:

```
docker run --rm -d --name="toshidaemon" -p 8080:8080 jonarod/toshi_search:slim
```

With peristent volume
```
docker run --rm -d --name="toshidaemon" -p 8080:8080 -v `pwd`:/home/Toshi/data jonarod/toshi_search:slim
```



### Build the whole thing again using `Dockerfile`:
Why would you do that?
80% of the time, to update the libraries: new toshi version, new rust environment... who knows!
For that, just get a copy of the `Dockerfile` in this repo and just run:

```
docker build -t jonarod/toshi_search .
```

(Note that it took me 25mn to build it from scratch on a Quad-core i5 8GB RAM)


### Minify using `docker-slim`:
If you built the image from scratch again, it might be wise to downsize it using `docker-slim`. Apart from shrinking the project from 2GB to 30MB (which I find cool personnally, no?!) it also reduces friction and hack opportunities (we only keep the daemon running and nothing else). For that, here is the command I used:

```
sudo docker-slim build --http-probe --http-probe-ports 8080 --tag jonarod/toshi_search:slim jonarod/toshi_search
```

### Run the daemon ! (with logs and new config.toml file)
```
docker run --rm -it --name="toshidaemon" -p 8080:8080 -v ~/Documents/Goodclic/backend/toshi/config.toml:/home/Toshi/config/config.toml jonarod/toshi_search:slim
```


### Test everything's fine:
From another terminal, the toshi daemon should be available at `http://localhost:8080`. To check everything is fine, just:

```
curl -X GET http://localhost:8080/
```

If everything is fine, you should get something like:

```
{"name":"Toshi Search","version":"0.1.1"}
```
