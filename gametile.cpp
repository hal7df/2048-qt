#include "gametile.h"

GameTile::GameTile(const QList<QVariant> &data)
{
    itemData = data;
}

QVariant GameTile::data(int index)
{
    return itemData.value(index);
}
