import redis.asyncio as redis

from app.config import get_settings

settings = get_settings()

redis_client: redis.Redis = redis.from_url(
    settings.redis_url,
    decode_responses=True,
    encoding="utf-8",
)


async def ping() -> bool:
    try:
        return bool(await redis_client.ping())
    except redis.RedisError:
        return False
