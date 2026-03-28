use crate::{
    chat::{EchoChatService, chat_server::ChatServer},
    login::{ChatLoginService, login_server::LoginServer},
};
use tonic::transport::Server;

mod chat;
mod login;

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let addr = "[::1]:50051".parse()?;

    let chat_login_service = ChatLoginService::default();
    let login_server = LoginServer::new(chat_login_service);

    let chat_service = EchoChatService::default();
    let chat_server = ChatServer::with_interceptor(chat_service, login::auth_interception);

    Server::builder()
        .add_service(login_server)
        .add_service(chat_server)
        .serve(addr)
        .await?;

    Ok(())
}
