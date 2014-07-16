#include "gamemodel.h"

GameModel::GameModel(QObject *parent) :
    QAbstractListModel(parent)
{
    int x, y, z;
    int randItem [2];
    QModelIndex ind;
    QMap<int,QVariant> obj_roles;

    x = 0;
    y = 0;

    for (z = 0; z < rowCount; z++)
    {
        obj_roles[ValueRole] = 0;
        obj_roles[XRole] = x;
        obj_roles[YRole] = y;

        setItemData(index(z),obj_roles);

        if (x == 3)
            x = 0;
        else
            x++;

        if (y == 3)
            y = 0;
        else
            y++;
    }

    randItem[0] = rand() % 16;
    randItem[1] = rand() % 16;

    while (randItem[1] == randItem[0])
        randItem[1] = rand() % 16;

    for (z = 0; z < 2; z++)
    {
        ind = index(randItem[z]);

        setData(ind,2*(rand() % 2 + 1),ValueRole);
    }
}

QHash<int,QByteArray> GameModel::roleNames() const
{
    QHash<int, QByteArray> roles;

    roles[ValueRole] = "value";
    roles[XRole] = "xpos";
    roles[YRole] = "ypos";

    return roles;
}

QVariant GameModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    GameTile* tile = static_cast<GameTile*>(index.internalPointer());

    return tile->data(role);
}
