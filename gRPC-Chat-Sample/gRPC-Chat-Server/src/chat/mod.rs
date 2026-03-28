use std::sync::Arc;

use tokio::sync::mpsc::{Sender, channel};
use tokio_stream::{StreamExt, wrappers::ReceiverStream};
use tonic::{Request, Response, Status, Streaming};

use crate::chat::chat_server::Chat;

tonic::include_proto!("chat");

type MessageSender = Sender<Result<ChatMessage, Status>>;

#[derive(Default)]
pub struct EchoChatService {
    clients: Arc<tokio::sync::Mutex<Vec<MessageSender>>>,
}

#[tonic::async_trait]
impl Chat for EchoChatService {
    type ChatStreamStream = ReceiverStream<Result<ChatMessage, Status>>;

    async fn chat_stream(
        &self,
        request: Request<Streaming<ChatMessage>>,
    ) -> Result<Response<Self::ChatStreamStream>, Status> {
        let mut messages = request.into_inner();

        let (tx, rx) = channel(4);

        {
            let mut clients = self.clients.lock().await;
            clients.push(tx.clone());
        }

        let clients = self.clients.clone();

        // Run echo
        tokio::spawn(async move {
            while let Some(Ok(message)) = messages.next().await {
                let _ = tx.send(Ok(message.clone())).await;
            }

            let mut clients = clients.lock().await;
            clients.retain(|x| !x.is_closed());
        });

        Ok(Response::new(ReceiverStream::new(rx)))
    }
}
