import QtQuick 2.0

ListModel {
    id: gameData

    Component.onCompleted: regenerate()

    ListElement {
        xpos:0
        ypos:0

        value: 0
    }
    ListElement {
        xpos:1
        ypos:0

        value: 0
    }
    ListElement {
        xpos:2
        ypos:0

        value: 0
    }
    ListElement {
        xpos:3
        ypos:0

        value: 0
    }
    ListElement {
        xpos:0
        ypos:1

        value: 0
    }
    ListElement {
        xpos:1
        ypos:1

        value: 0
    }
    ListElement {
        xpos:2
        ypos:1

        value: 0
    }
    ListElement {
        xpos:3
        ypos:1

        value: 0
    }
    ListElement {
        xpos:0
        ypos:2

        value: 0
    }
    ListElement {
        xpos:1
        ypos:2

        value: 0
    }
    ListElement {
        xpos:2
        ypos:2

        value: 0
    }
    ListElement {
        xpos:3
        ypos:2

        value: 0
    }
    ListElement {
        xpos:0
        ypos:3

        value: 0
    }
    ListElement {
        xpos:1
        ypos:3

        value: 0
    }
    ListElement {
        xpos:2
        ypos:3

        value: 0
    }
    ListElement {
        xpos:3
        ypos:3

        value: 0
    }

    function swap (ind1,ind2)
    {
        var tile1, tile2;

        tile1 = new Object;
        tile2 = new Object;

        tile1.x = get(ind1).xpos;
        tile1.y = get(ind1).ypos;

        tile2.x = get(ind2).xpos;
        tile2.y = get(ind2).ypos;

        move(ind1,ind2,1);
        setProperty(ind2,"xpos",tile2.x);
        setProperty(ind2,"ypos",tile2.y);

        if (ind1 > ind2)
        {
            move(ind2+1,ind1,1);
            setProperty(ind1,"xpos",tile1.x);
            setProperty(ind1,"ypos",tile1.y);
        }
        else
        {
            move(ind2-1,ind1,1);
            setProperty(ind1,"xpos",tile1.x);
            setProperty(ind1,"ypos",tile1.y);
        }
    }

    function merge (from,to)
    {
        if (get(from).value == get(to).value)
        {
            setProperty(to,"value",get(to).value+get(from).value);
            setProperty(from,"value",0);
        }
    }

    function indexAtCoord (x,y)
    {
        var j;

        j = -1;

        for (var i = 0; i < count; i++)
        {
            if (get(i).xpos === x && get(i).ypos === y)
                j = i;
        }

        return j;
    }

    function getTileAtCoord (x,y)
    {
        return get(indexAtCoord(x,y));
    }

    function doesTileExist (val)
    {
        var tile;

        tile = false;

        for (var i = 0; i < count; i++)
        {
            if (get(i).value == val)
                tile = true;
        }

        return tile;
    }

    function validMovesLeft (ind)
    {
        var validMoves;
        var x, y;

        x = get(ind).xpos;
        y = get(ind).ypos;
        validMoves = false;

        if (get(ind).value == 0)
            validMoves = true;

        if (x > 0 && (getTileAtCoord(x-1,y).value == get(ind).value || getTileAtCoord(x-1,y) == 0))
            validMoves = true;

        if (x < 3 && (getTileAtCoord(x+1,y).value == get(ind).value || getTileAtCoord(x+1,y) == 0))
            validMoves = true;

        if (y > 0 && (getTileAtCoord(x,y-1).value == get(ind).value || getTileAtCoord(x,y-1) == 0))
            validMoves = true;

        if (y < 3 && (getTileAtCoord(x,y+1).value == get(ind).value || getTileAtCoord(x,y+1) == 0))
            validMoves = true;

        return validMoves;
    }

    function regenerate ()
    {
        for (var i = 0; i < count; i++)
        {
            setProperty(i,"value",0);
        }

        for (i = 0; i < 2; i++)
            generate();
    }

    function generate ()
    {
        var loopflag;
        var remainingTiles;

        remainingTiles = [];

        do
        {
            loopflag = true;
            var t = Math.floor(Math.random()*16);

            if (get(t).value != 0)
            {
                loopflag = false;
                if (remainingTiles.indexOf(t) == -1)
                    remainingTiles.push(t);
            }
        }while(!loopflag && remainingTiles.length < 16);

        if (remainingTiles.length < 16)
            setProperty(t,"value",(2*Math.floor(Math.random()+1.5)));
    }
}
