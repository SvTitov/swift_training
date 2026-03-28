# gRPC iOS Client & Rust Server

## Server Setup

The server is built with **Rust** using the **Tonic** framework. You need a Rust environment installed to build and run it.

### Code Generation

The server automatically generates Rust files from `.proto` definitions during the build process.

To build the server and generate the necessary code run:

```bash
cargo build
```

## iOS Application Setup

### Prerequisites

Ensure you have the following tools installed:

1. **Protocol Buffers Compiler (`protoc`)**
2. **gRPC Swift Plugin**: Install via Homebrew:

   ```bash
   brew install protoc-gen-grpc-swift
   ```

### Generate Swift Code

Run the following command to generate Swift files from `login.proto` and `chat.proto`.
*Note: Execute this command from the directory where the `.proto` files are located.*

```bash
protoc \
  --grpc-swift_out=Generated/ \
  --swift_out=Generated/ \
  --proto_path=../gRPC-Chat-Shared/ \
  login.proto \
  chat.proto
```
