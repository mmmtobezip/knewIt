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
    __tablename__ = "users"

    user_id: Mapped[str] = mapped_column(String(64), primary_key=True)
    name: Mapped[str | None] = mapped_column(String(128))
    role: Mapped[UserRole] = mapped_column(
        Enum(UserRole, name="user_role"),
        nullable=False,
        default=UserRole.SALES,
    )


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
