fn main() -> Result<(), Box<dyn std::error::Error>> {
    tonic_prost_build::compile_protos("../gRPC-Chat-Shared/login.proto")?;
    tonic_prost_build::compile_protos("../gRPC-Chat-Shared/chat.proto")?;
    Ok(())
}
