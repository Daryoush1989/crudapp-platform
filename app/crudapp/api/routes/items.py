from fastapi import APIRouter, Depends, HTTPException, Query, Response, status
from sqlalchemy.orm import Session

from crudapp.db.session import get_db
from crudapp.models.item import Item
from crudapp.schemas.item import ItemCreate, ItemRead, ItemUpdate
from crudapp.services import items as item_service

router = APIRouter(prefix="/items", tags=["items"])


def get_item_or_404(db: Session, item_id: int) -> Item:
    item = item_service.get_item(db=db, item_id=item_id)

    if item is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Item not found",
        )

    return item


@router.post("/", response_model=ItemRead, status_code=status.HTTP_201_CREATED)
def create_item(
    item_in: ItemCreate,
    db: Session = Depends(get_db),
) -> Item:
    return item_service.create_item(db=db, item_in=item_in)


@router.get("/", response_model=list[ItemRead])
def list_items(
    skip: int = Query(default=0, ge=0),
    limit: int = Query(default=100, ge=1, le=100),
    db: Session = Depends(get_db),
) -> list[Item]:
    return item_service.list_items(db=db, skip=skip, limit=limit)


@router.get("/{item_id}", response_model=ItemRead)
def get_item(
    item_id: int,
    db: Session = Depends(get_db),
) -> Item:
    return get_item_or_404(db=db, item_id=item_id)


@router.patch("/{item_id}", response_model=ItemRead)
def update_item(
    item_id: int,
    item_in: ItemUpdate,
    db: Session = Depends(get_db),
) -> Item:
    item = get_item_or_404(db=db, item_id=item_id)
    return item_service.update_item(db=db, item=item, item_in=item_in)


@router.delete("/{item_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_item(
    item_id: int,
    db: Session = Depends(get_db),
) -> Response:
    item = get_item_or_404(db=db, item_id=item_id)
    item_service.delete_item(db=db, item=item)
    return Response(status_code=status.HTTP_204_NO_CONTENT)
