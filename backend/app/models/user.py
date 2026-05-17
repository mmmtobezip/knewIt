from enum import StrEnum

from sqlalchemy import Enum, ForeignKey, PrimaryKeyConstraint, String
from sqlalchemy.orm import Mapped, mapped_column

from app.models.base import Base, TimestampMixin


class UserRole(StrEnum):
    SALES = "sales"
    MANAGER = "manager"
    ADMIN = "admin"


class AssignmentRole(StrEnum):
    PRIMARY = "primary"
    SUPPORT = "support"


class User(Base, TimestampMixin):
    """사용자 (PRD 0516).

    primary_product_code: 담당자:제품 = 1:1 매핑. 박지은=선재, 박현웅=후판.
        로그인 화면 없이 프로필 picker 로 시나리오 시작 시 자동 lv1 활성용.
        NULL 허용 (관리자/매니저/기존 사원은 미지정).
    """
    __tablename__ = "users"

    user_id: Mapped[str] = mapped_column(String(64), primary_key=True)
    name: Mapped[str | None] = mapped_column(String(128))
    role: Mapped[UserRole] = mapped_column(
        Enum(UserRole, name="user_role"),
        nullable=False,
        default=UserRole.SALES,
    )
    primary_product_code: Mapped[str | None] = mapped_column(String(64), nullable=True)


class OrgHierarchy(Base):
    __tablename__ = "org_hierarchy"
    __table_args__ = (PrimaryKeyConstraint("manager_id", "subordinate_id"),)

    manager_id: Mapped[str] = mapped_column(
        String(64),
        ForeignKey("users.user_id", ondelete="CASCADE"),
    )
    subordinate_id: Mapped[str] = mapped_column(
        String(64),
        ForeignKey("users.user_id", ondelete="CASCADE"),
    )


class AssignedCustomer(Base):
    __tablename__ = "assigned_customers"
    __table_args__ = (PrimaryKeyConstraint("user_id", "customer_id"),)

    user_id: Mapped[str] = mapped_column(
        String(64),
        ForeignKey("users.user_id", ondelete="CASCADE"),
    )
    customer_id: Mapped[str] = mapped_column(
        String(128),
        ForeignKey("customer_profiles.customer_id", ondelete="CASCADE"),
    )
    role: Mapped[AssignmentRole] = mapped_column(
        Enum(AssignmentRole, name="assignment_role"),
        nullable=False,
        default=AssignmentRole.PRIMARY,
    )
    assigned_at: Mapped[str] = mapped_column(String(10), nullable=False)
