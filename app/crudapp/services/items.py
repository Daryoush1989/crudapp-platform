from sqlalchemy import select
from sqlalchemy.orm import Session

from crudapp.models.item import Item
from crudapp.schemas.item import ItemCreate, ItemUpdate


def list_items(db: Session, skip: int = 0, limit: int = 100) -> list[Item]:
    statement = select(Item).order_by(Item.id).offset(skip).limit(limit)
    return list(db.scalars(statement).all())


def get_item(db: Session, item_id: int) -> Item | None:
    return db.get(Item, item_id)


def create_item(db: Session, item_in: ItemCreate) -> Item:
    item = Item(**item_in.model_dump())
    db.add(item)
    db.commit()
    db.refresh(item)
    return item


def update_item(db: Session, item: Item, item_in: ItemUpdate) -> Item:
    update_data = item_in.model_dump(exclude_unset=True)

    for field, value in update_data.items():
        setattr(item, field, value)

    db.add(item)
    db.commit()
    db.refresh(item)
    return item


def delete_item(db: Session, item: Item) -> None:
    db.delete(item)
    db.commit()
