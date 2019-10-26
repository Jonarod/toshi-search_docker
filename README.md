### Get started

For 90% of users, just copy-paste this:

```
docker run --rm -d --name="toshidaemon" -p 8080:8080 -v "/$(pwd)/data:/home/Toshi/data" jonarod/toshi_search:slim
```



### Build the whole thing again using `Dockerfile`:
Why would you do that?
80% of the time, to update the libraries: new Toshi version, new Rust environment... who knows!
For that, get a copy of the `Dockerfile` in this repo and just run:

```
docker build -t <USERNAME>/toshi_search .
```

(Note that it took me 25mn to build it from scratch on a Quad-core i5 8GB RAM)


### Minify using `docker-slim`:
If you built the image from scratch, it might be wise to downsize it using `docker-slim`. Apart from shrinking the project from 2GB to 30MB (which I find cool) it also reduces friction and hack opportunities (we only keep the daemon running and nothing else). For that, here is the command I used:

```
sudo docker-slim build --http-probe --http-probe-ports 8080 --tag jonarod/toshi_search:slim jonarod/toshi_search
```

### Run the daemon ! (with logs and new config.toml file)
```
docker run --rm -it --name="toshidaemon" -p 8080:8080 -v /$(pwd)/config.toml:/home/Toshi/config/config.toml -v /$(pwd)/data:/home/Toshi/data jonarod/toshi_search:slim
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

### Create index

```
curl -X PUT http://localhost:8080/test_index/_create \
    -H 'Content-Type: application/json' \
    -d '[{"name": "test_text","type": "text","options": {"indexing": {"record": "position","tokenizer": "default"},"stored": true}},{"name": "test_i64","type": "i64","options": {"indexed": true,"stored": true}},{"name": "test_u64","type": "u64","options": {"indexed": true,"stored": true}}]'
```

### Add data to index

```
curl -X PUT http://localhost:8080/test_index \
    -H 'Content-Type: application/json' \
    -d '{"options": { "commit": true },"document": {"test_text": "This is my document text", "test_u64": 10, "test_i64": -10}}'
```

### Search data

```
curl -X POST http://localhost:8080/test_index \
    -H 'Content-Type: application/json' \
    -d '{ "query": {"term": {"test_text": "document" } }, "limit": 10 }'
```

### Official docs

This repo is just a Dockerized version of this great official repo: [https://github.com/toshi-search/Toshi](Toshi).

Go find the official docs there and help me maintain the Docker up to date :)
