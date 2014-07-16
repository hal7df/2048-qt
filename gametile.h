#ifndef GAMETILE_H
#define GAMETILE_H

#include <QList>
#include <QVariant>

class GameTile
{
public:
    GameTile(QList<QVariant> data);

    QVariant data (int index);
private:
    QList<QVariant> itemData;
};

#endif // GAMETILE_H
