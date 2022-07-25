#[macro_use]
extern crate rocket;

use std::env;

use chrono::serde::ts_milliseconds;
use rocket::serde::{Deserialize, Serialize};
use rocket::{http::Status, serde::json::Json, State};
use sqlx::{postgres::PgPoolOptions, Executor, Pool, Postgres};

#[derive(Debug, Serialize, Deserialize)]
#[serde(crate = "rocket::serde")]
struct ItemInfo {
    id: i32,
    product: String,
    place: String,
    amount: i32,
    #[serde(with = "ts_milliseconds")]
    created_at: chrono::DateTime<chrono::Utc>,
}

#[get("/stock")]
async fn get_stock(pool: &State<Pool<Postgres>>) -> Result<Json<Vec<ItemInfo>>, Status> {
    let res = sqlx::query_as!(ItemInfo, "SELECT * FROM stock")
        .fetch_all(&**pool)
        .await;

    if let Err(why) = res {
        eprintln!("error querying stock: {why}");
        return Err(Status::InternalServerError);
    }

    Ok(Json(res.unwrap()))
}

#[rocket::main]
async fn main() -> anyhow::Result<()> {
    let _ = dotenv::dotenv();

    let database_url = env::var("DATABASE_URL")?;

    let pool = PgPoolOptions::new()
        .max_connections(5)
        .connect(&database_url)
        .await?;

    sqlx::migrate!().run(&pool).await?;

    rocket::build()
        .mount("/", routes![get_stock])
        .manage(pool)
        .launch()
        .await?;

    Ok(())
}
