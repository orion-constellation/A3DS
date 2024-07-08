FROM rust:latest as rust_builder


RUN USER=root cargo new --bin data_processing
WORKDIR /data_processing

COPY data_processing/Cargo.toml data_processing/Cargo.lock ./

RUN cargo build --release
RUN rm src/*.rs

COPY data_processing/src ./src

RUN cargo build --release

# Stage 2: Build the main application
FROM python:3.10-slim as python_builder


RUN pip install poetry

WORKDIR /app

COPY pyproject.toml poetry.lock ./


RUN poetry install --no-root --no-dev

COPY . .

RUN poetry install --no-dev


FROM python:3.10-slim

COPY --from=python_builder /usr/local /usr/local

RUN apt-get update && apt-get install -y \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy the built Rust application
COPY --from=rust_builder /data_processing/target/release/data_processing /usr/local/bin/data_processing

# Set the working directory
WORKDIR /app

# Copy the application files
COPY . .

# Set the entry point
CMD ["poetry", "run", "python", "main.py"]