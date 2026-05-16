from datetime import date as Date
from enum import StrEnum

from sqlalchemy import BigInteger, Enum, Float, String, UniqueConstraint
from sqlalchemy import Date as SQLDate
from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import Base, TimestampMixin


class Direction(StrEnum):
    UP = "UP"
    DOWN = "DOWN"


class Indicator(Base, TimestampMixin):
    __tablename__ = "indicators"
    __table_args__ = (
        UniqueConstraint("feature_name", "date", "source", name="uq_indicator_feature_date_source"),
    )

    id: Mapped[int] = mapped_column(BigInteger, primary_key=True, autoincrement=True)
    source: Mapped[str] = mapped_column(String(64), nullable=False)
    country: Mapped[str | None] = mapped_column(String(32))
    category_big: Mapped[str | None] = mapped_column(String(32))
    category_mid: Mapped[str | None] = mapped_column(String(32))
    category_small: Mapped[str | None] = mapped_column(String(32))
    feature_name: Mapped[str] = mapped_column(String(256), nullable=False, index=True)
    date: Mapped[Date] = mapped_column(SQLDate, nullable=False, index=True)
    value: Mapped[float] = mapped_column(Float, nullable=False)
    unit: Mapped[str] = mapped_column(String(32), nullable=False)
    cycle: Mapped[str] = mapped_column(String(2), nullable=False)


class TriggerEvent(Base, TimestampMixin):
    __tablename__ = "trigger_events"

    event_id: Mapped[str] = mapped_column(String(64), primary_key=True)
    feature: Mapped[str] = mapped_column(String(256), nullable=False)
    product_code: Mapped[str] = mapped_column(String(32), nullable=False, index=True)
    customer_id: Mapped[str | None] = mapped_column(String(128), index=True)
    change_rate: Mapped[float] = mapped_column(Float, nullable=False)
    direction: Mapped[Direction] = mapped_column(Enum(Direction, name="event_direction"), nullable=False)
    date: Mapped[Date] = mapped_column(SQLDate, nullable=False, index=True)
