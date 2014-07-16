#ifndef GAMEMODEL_H
#define GAMEMODEL_H

#include <QAbstractListModel>
#include <QModelIndex>
#include <QVariant>

#include <cstdlib>

#include "gametile.h"

class GameModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum GameRoles {
        ValueRole = Qt::UserRole + 1,
        XRole,
        YRole
    };

    enum MoveDirection {
        Up,
        Right,
        Down,
        Left
    };

    explicit GameModel(QObject *parent = 0);

    QHash<int,QByteArray> roleNames() const;
    int rowCount (const QModelIndex &parent) const;
    QVariant data (const QModelIndex &index, int role) const;

    /** INTERNAL DATA MANAGEMENT METHODS **/

    void swap (int index1, int index2);
    void merge (int from, int to);

    /** QML INVOKABLE METHODS **/
    Q_INVOKABLE void createNew();
    Q_INVOKABLE void generate();

    Q_INVOKABLE bool doesTileExist (int value);
    Q_INVOKABLE void makeMove (MoveDirection dir);

    Q_INVOKABLE int indexAtCoord (int x, int y);
    Q_INVOKABLE QVariant getTileAtCoord (int x, int y);
signals:
    void addScore (int score);

public slots:

};

#endif // GAMEMODEL_H
