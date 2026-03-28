tonic::include_proto!("login");

use std::sync::RwLock;
use std::{collections::HashMap, sync::LazyLock};
use tonic::{Request, Response, Status};

use crate::login::login_server::Login;

/// Mock user data.
///
/// In memory storage
///
static USERS_DATA: LazyLock<RwLock<HashMap<&'static str, UserInfo>>> = LazyLock::new(|| {
    RwLock::new(HashMap::from([(
        "admin",
        UserInfo {
            pass: "123".to_string(),
            token: None,
        },
    )]))
});

/// Mock use session
///
/// In memory storage
///
static USERS_SESSIONS: LazyLock<RwLock<HashMap<String, String>>> =
    LazyLock::new(|| RwLock::new(HashMap::default()));

struct UserInfo {
    pass: String,
    token: Option<String>,
}

#[derive(Debug, Default)]
pub struct ChatLoginService;

#[tonic::async_trait]
impl Login for ChatLoginService {
    async fn authentication(
        &self,
        request: Request<AuthenticationRequest>,
    ) -> Result<Response<AuthenticationResponse>, Status> {
        let request = request.into_inner();
        let login = request.login.as_str();

        let is_authenticated = {
            let data = USERS_DATA.read().unwrap();
            data.get(login)
                .map(|x| x.pass == request.password)
                .unwrap_or(false)
        };

        if !is_authenticated {
            return Err(Status::unauthenticated("Invalid login or password"));
        }

        let token = uuid::Uuid::new_v4().to_string();

        {
            let mut data = USERS_DATA.write().unwrap();
            let mut sessions = USERS_SESSIONS.write().unwrap();
            if let Some(user) = data.get_mut(login) {
                user.token = Some(token.clone());
                sessions.insert(token.clone(), login.to_string());
            }
        }

        Ok(Response::new(AuthenticationResponse { token }))
    }
}

pub fn auth_interception(req: Request<()>) -> Result<Request<()>, Status> {
    let token = req
        .metadata()
        .get("authorization")
        .ok_or_else(|| Status::unauthenticated("Invalid token"))?;

    let token = token
        .to_str()
        .map_err(|_| Status::unauthenticated("Invalid token"))?;

    if !token.starts_with("Bearer ") {
        return Err(Status::unauthenticated("Invalid token"));
    }

    let token = &token["Bearer ".len()..token.len()];

    {
        let session = USERS_SESSIONS.read().unwrap();
        if session.get(token).is_none() {
            return Err(Status::unauthenticated("Invalid token"));
        }
    }

    Ok(req)
}
