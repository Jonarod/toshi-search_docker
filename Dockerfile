FROM rust:1.38-slim

RUN apt-get update
RUN apt-get install -y git

WORKDIR /home

RUN git clone https://github.com/toshi-search/Toshi.git

WORKDIR /home/Toshi

RUN cargo build --release


# FROM rust:1.38-slim
# COPY --from=0 /home/ /home/

COPY ./config.toml /home/Toshi/config/config.toml

EXPOSE 8080

CMD ["./target/release/toshi"]