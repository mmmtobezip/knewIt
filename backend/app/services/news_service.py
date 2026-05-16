"""뉴스 수집 (Naver + NewsAPI 직접 호출).

PRD 0514 메인 대시보드의 인과 흐름도(차트2) evidence 용도.
잔여 태스크 #7 (BACKLOG): Vector DB(ChromaDB) 도입 시 인터페이스 그대로 교체.
"""
from __future__ import annotations

import asyncio
import logging
import re
from datetime import datetime
from email.utils import parsedate_to_datetime

import httpx

from app.config import get_settings
from app.schemas.domain import NewsDoc

logger = logging.getLogger(__name__)
SETTINGS = get_settings()

_NAVER_URL = "https://openapi.naver.com/v1/search/news.json"
_NEWSAPI_URL = "https://newsapi.org/v2/everything"
_HTML_TAG = re.compile(r"<[^>]+>")


def _strip_html(s: str) -> str:
    return _HTML_TAG.sub("", s).replace("&quot;", '"').replace("&amp;", "&").strip()


def _parse_naver_date(s: str) -> datetime:
    try:
        return parsedate_to_datetime(s)
    except (TypeError, ValueError):
        return datetime.now()


def _parse_iso(s: str) -> datetime:
    return datetime.fromisoformat(s.replace("Z", "+00:00"))


# 제품 + 핵심 지표명 → 검색 키워드 매핑 (긴 한글 지표명은 검색 매칭 약함).
_PRODUCT_QUERY = {
    "HR(고로밀)": ("열연강판 가격", "hot rolled steel price"),
    "후판": ("후판 가격", "steel plate price"),
    "냉연(CR)": ("냉연강판 가격", "cold rolled steel price"),
    "STS 304": ("스테인리스 304 가격", "stainless steel 304 price"),
    "부산물(철스크랩)": ("철스크랩 가격", "ferrous scrap price"),
    "선재": ("선재 가격", "wire rod steel price"),
}


def query_for_indicator(indicator: str, product: str) -> tuple[str, str]:
    """(한글 query, 영문 query) 튜플. 제품 매핑 우선, 없으면 지표명 일부."""
    if product in _PRODUCT_QUERY:
        return _PRODUCT_QUERY[product]
    short = indicator.split()[0] if indicator else "철강"
    return (short, "steel")


class NewsService:
    def __init__(self) -> None:
        self._timeout = httpx.Timeout(10.0, connect=5.0)

    async def search(
        self, ko_query: str, en_query: str | None = None, *, per_source: int = 5
    ) -> list[NewsDoc]:
        en = en_query or ko_query
        async with httpx.AsyncClient(timeout=self._timeout) as client:
            naver, intl = await asyncio.gather(
                self._fetch_naver(client, ko_query, per_source),
                self._fetch_newsapi(client, en, per_source),
                return_exceptions=True,
            )
        out: list[NewsDoc] = []
        for result in (naver, intl):
            if isinstance(result, list):
                out.extend(result)
            elif isinstance(result, Exception):
                logger.warning("news source failed: %s", result)
        out.sort(key=lambda n: n.published_at, reverse=True)
        return out[: per_source * 2]

    async def _fetch_naver(
        self, client: httpx.AsyncClient, query: str, count: int
    ) -> list[NewsDoc]:
        if not (SETTINGS.naver_client_id and SETTINGS.naver_client_secret):
            return []
        r = await client.get(
            _NAVER_URL,
            headers={
                "X-Naver-Client-Id": SETTINGS.naver_client_id,
                "X-Naver-Client-Secret": SETTINGS.naver_client_secret,
            },
            params={"query": query, "display": count, "sort": "date"},
        )
        r.raise_for_status()
        items = r.json().get("items", [])
        return [
            NewsDoc(
                source="Naver",
                title=_strip_html(item.get("title", "")),
                summary=_strip_html(item.get("description", "")),
                url=item.get("link") or item.get("originallink", ""),
                published_at=_parse_naver_date(item.get("pubDate", "")),
            )
            for item in items
        ]

    async def _fetch_newsapi(
        self, client: httpx.AsyncClient, query: str, count: int
    ) -> list[NewsDoc]:
        if not SETTINGS.newsapi_key:
            return []
        r = await client.get(
            _NEWSAPI_URL,
            headers={"X-Api-Key": SETTINGS.newsapi_key},
            params={
                "q": query,
                "pageSize": count,
                "sortBy": "publishedAt",
                "language": "en",
            },
        )
        r.raise_for_status()
        articles = r.json().get("articles", [])
        return [
            NewsDoc(
                source=a.get("source", {}).get("name", "Unknown"),
                title=a.get("title") or "",
                summary=a.get("description") or "",
                url=a.get("url") or "",
                published_at=_parse_iso(a["publishedAt"]),
            )
            for a in articles
            if a.get("publishedAt")
        ]


_news_singleton: NewsService | None = None


def get_news_service() -> NewsService:
    global _news_singleton
    if _news_singleton is None:
        _news_singleton = NewsService()
    return _news_singleton


__all__ = ["NewsService", "get_news_service", "query_for_indicator"]
