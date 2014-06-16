import QtQuick 2.0
import QtQuick.Controls 1.1
import "colorutils.js" as ColorUtils

Rectangle {
    id: numberGrid

    property alias model: playGrid.model
    property int goal
    property bool canDecreasePower: !model.doesTileExist(goal/2)

    signal loss
    signal win
    signal restart
    signal addScore (int diff)

    height: width

    color: "#22ffffff"

    anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter }

    clip: true

    onLoss: {
        gameChangeDisplay.opacity = 1.0;
        gameChangeLabel.text = "You lost!";
        gameMenu.open = true;
    }

    onWin: {
        gameChangeDisplay.opacity = 1.0;
        gameChangeLabel.text = "You won!";
        gameMenu.open = true;
    }

    onGoalChanged: {
        if (!model.doesTileExist(goal))
        {
            gameChangeDisplay.opacity = 0.0;
            gameMenu.open = false;
        }
    }

    GridView
    {
        id: playGrid

        anchors { fill: parent; margins: 20 }

        cellHeight: height/4
        cellWidth: width/4

        interactive: false

        model: GameModel { id: gameData }

        move: Transition {
            NumberAnimation { properties: "x,y"; duration: 100 }
        }

        verticalLayoutDirection: GridView.BottomToTop

        delegate: Rectangle {

            width: playGrid.cellWidth
            height: playGrid.cellHeight

            color: ColorUtils.getBackgroundColor(value)

            Behavior on color {
                ColorAnimation { easing.type: Easing.InOutQuad }
            }

            Text {
                anchors.centerIn: parent

                text: value != 0 ? value : ""
                font.pixelSize: parent.height/2
                font.weight: Font.Light

                horizontalAlignment: Text.AlignHCenter

                width: parent.width - 4
                scale: paintedWidth > width ? (width/paintedWidth) : 1

                color: ColorUtils.getTextColor(value)

                Behavior on color {
                    ColorAnimation { easing.type: Easing.InOutQuad }
                }
            }
        }
    }

    Rectangle {
        id: gameChangeDisplay

        anchors.fill: parent

        radius: parent.radius
        color: "#cccccc"
        opacity: 0.0

        Behavior on opacity {
            NumberAnimation { duration: 1000 }
        }

        visible: opacity != 0.0

        onVisibleChanged: {
            if (visible)
            {
                opacity = 0.5;

                if (scoreContain.loss)
                    gameChangeLabel.text = "You lost!";

                if (scoreContain.win)
                    gameChangeLabel.text = "You won!";
            }
            else
            {
                opacity = 0.0;
            }
        }

        Text {
            id: gameChangeLabel

            anchors.centerIn: parent

            text: ""

            font.pixelSize: parent.height/6
        }
    }

    MultiPointTouchArea {
        id: gestureMover

        property bool actionCompleted: false

        anchors.fill: parent

        maximumTouchPoints: 1
        enabled: !gameChangeDisplay.visible
        focus: true

        onUpdated: {
            if (!actionCompleted)
            {
                var xdiff, ydiff;

                xdiff = touchPoints[0].x - touchPoints[0].startX;
                ydiff = touchPoints[0].y - touchPoints[0].startY;

                if (Math.abs(xdiff) > Math.abs(ydiff))
                {
                    if (xdiff > 20)
                    {
                        numberGrid.moveRight();
                        actionCompleted = true;
                    }
                    else if (xdiff < -20)
                    {
                        numberGrid.moveLeft();
                        actionCompleted = true;
                    }
                }
                else if (Math.abs(xdiff) < Math.abs(ydiff))
                {
                    if (ydiff > 20)
                    {
                        numberGrid.moveDown();
                        actionCompleted = true;
                    }
                    else if (ydiff < -20)
                    {
                        numberGrid.moveUp();
                        actionCompleted = true;
                    }
                }
            }
        }

        onReleased: actionCompleted = false

        Keys.onPressed: {

            if (!gameChangeDisplay.visible)
            {
                event.accepted = true;

                if (event.key == Qt.Key_Up)
                    numberGrid.moveUp();
                else if (event.key == Qt.Key_Down)
                    numberGrid.moveDown();
                else if (event.key == Qt.Key_Right)
                    numberGrid.moveRight();
                else if (event.key == Qt.Key_Left)
                    numberGrid.moveLeft();
                else if (event.key == Qt.Key_R)
                {
                    numberGrid.resetGame();
                }

                else
                {
                    event.accepted = false;
                }
            }
            else
            {

                if (event.key == Qt.Key_R)
                {
                    numberGrid.resetGame();
                    event.accepted = true;
                }
                event.accepted = false;
            }
        }
    }

    Item {
        id: gameMenu

        property bool open: false

        anchors { left: parent.left; right: parent.right }

        height: parent.height/4
        y: open ? parent.height-height : parent.height

        Behavior on y {
            NumberAnimation { easing.type: Easing.InOutQuad }
        }

        ToolButton {
            id: resetButton

            property string iconSize: {
                if (height < 48)
                    return "mdpi";
                else if (height >= 48 && height < 64)
                    return "hdpi";
                else if (height >= 64)
                    return "xhdpi";
            }

            anchors { top: parent.top; bottom: parent.bottom; horizontalCenter: parent.horizontalCenter; margins: 2 }

            width: height

            iconSource: "images/"+iconSize+"/ic_reset.png"
            onClicked: {
                parent.open = false;
                numberGrid.resetGame();
            }
        }
    }

    function resetGame()
    {
        gameData.regenerate();
        gameChangeDisplay.opacity = 0.0;
        restart();
    }

    /** MOVE FUNCTIONS **/

    function moveUp ()
    {
        var x,y;
        var tileMoved;

        tileMoved = false;

        console.log("Move up event triggered");

        //Move everything up
        for (x = 0; x < 4; x++)
        {
            for (y = 2; y >= 0; y--)
            {
                if (gameData.getTileAtCoord(x,y).value !== 0)
                {
                    if (gameData.getTileAtCoord(x,y+1).value === 0)
                    {
                        gameData.swap(gameData.indexAtCoord(x,y),gameData.indexAtCoord(x,y+1));
                        tileMoved = true;
                        if (y < 2)
                            y += 2;
                    }
                }
            }
        }

        //Merge tiles
        for (x = 0; x < 4; x++)
        {
            for (y = 2; y >= 0; y--)
            {
                if (gameData.getTileAtCoord(x,y).value !== 0)
                {
                    if (gameData.getTileAtCoord(x,y+1).value == gameData.getTileAtCoord(x,y).value)
                    {
                        gameData.merge(gameData.indexAtCoord(x,y),gameData.indexAtCoord(x,y+1));
                        tileMoved = true;
                        numberGrid.addScore(gameData.getTileAtCoord(x,y+1).value);
                    }
                }
            }
        }

        //Move everything up again
        for (x = 0; x < 4; x++)
        {
            for (y = 2; y >= 0; y--)
            {
                if (gameData.getTileAtCoord(x,y).value !== 0)
                {
                    if (gameData.getTileAtCoord(x,y+1).value === 0)
                    {
                        gameData.swap(gameData.indexAtCoord(x,y),gameData.indexAtCoord(x,y+1));
                        if (y < 2)
                            y += 2;
                    }
                }
            }
        }

        if (tileMoved)
            afterMove();
    }
    function moveDown ()
    {
        var x,y;
        var tileMoved;

        tileMoved = false;

        console.log("Move down event triggered");

        //Move everything down
        for (x = 0; x < 4; x++)
        {
            for (y = 1; y < 4; y++)
            {
                if (gameData.getTileAtCoord(x,y).value !== 0)
                {
                    if (gameData.getTileAtCoord(x,y-1).value === 0)
                    {
                        gameData.swap(gameData.indexAtCoord(x,y),gameData.indexAtCoord(x,y-1));
                        tileMoved = true;
                        if (y > 1)
                            y -= 2;
                    }
                }
            }
        }

        //Merge tiles
        for (x = 0; x < 4; x++)
        {
            for (y = 1; y < 4; y++)
            {
                if (gameData.getTileAtCoord(x,y).value !== 0)
                {
                    if (gameData.getTileAtCoord(x,y-1).value == gameData.getTileAtCoord(x,y).value)
                    {
                        gameData.merge(gameData.indexAtCoord(x,y),gameData.indexAtCoord(x,y-1));
                        tileMoved = true;
                        numberGrid.addScore(gameData.getTileAtCoord(x,y-1).value);
                    }
                }
            }
        }

        //Move everything down again
        for (x = 0; x < 4; x++)
        {
            for (y = 1; y < 4; y++)
            {
                if (gameData.getTileAtCoord(x,y).value !== 0)
                {
                    if (gameData.getTileAtCoord(x,y-1).value === 0)
                    {
                        gameData.swap(gameData.indexAtCoord(x,y),gameData.indexAtCoord(x,y-1));
                        if (y > 1)
                            y -= 2;
                    }
                }
            }
        }

        if (tileMoved)
            afterMove();
    }

    function moveRight ()
    {
        var x,y;
        var tileMoved;

        tileMoved = false;

        console.log("Move right event triggered");

        //Move everything right
        for (y = 0; y < 4; y++)
        {
            for (x = 2; x >= 0; x--)
            {
                if (gameData.getTileAtCoord(x,y).value !== 0)
                {
                    if (gameData.getTileAtCoord(x+1,y).value === 0)
                    {
                        gameData.swap(gameData.indexAtCoord(x,y),gameData.indexAtCoord(x+1,y));
                        tileMoved = true;
                        if (x < 2)
                            x += 2;
                    }
                }
            }
        }

        //Merge tiles
        for (y = 0; y < 4; y++)
        {
            for (x = 2; x >= 0; x--)
            {
                if (gameData.getTileAtCoord(x,y).value !== 0)
                {
                    if (gameData.getTileAtCoord(x,y).value == gameData.getTileAtCoord(x+1,y).value)
                    {
                        gameData.merge(gameData.indexAtCoord(x,y),gameData.indexAtCoord(x+1,y));
                        tileMoved = true;
                        numberGrid.addScore(gameData.getTileAtCoord(x+1,y).value);
                    }
                }
            }
        }

        //Move everything down again
        for (y = 0; y < 4; y++)
        {
            for (x = 2; x >= 0; x--)
            {
                if (gameData.getTileAtCoord(x,y).value !== 0)
                {
                    if (gameData.getTileAtCoord(x+1,y).value === 0)
                    {
                        gameData.swap(gameData.indexAtCoord(x,y),gameData.indexAtCoord(x+1,y));
                        if (x > 1)
                            x += 2;
                    }
                }
            }
        }

        if (tileMoved)
            afterMove();
    }

    function moveLeft ()
    {
        var x,y;
        var tileMoved;

        tileMoved = false;

        console.log("Move left event triggered");

        //Move everything right
        for (y = 0; y < 4; y++)
        {
            for (x = 1; x < 4; x++)
            {
                if (gameData.getTileAtCoord(x,y).value !== 0)
                {
                    if (gameData.getTileAtCoord(x-1,y).value === 0)
                    {
                        gameData.swap(gameData.indexAtCoord(x,y),gameData.indexAtCoord(x-1,y));
                        tileMoved = true;
                        if (x > 1)
                            x -= 2;
                    }
                }
            }
        }

        //Merge tiles
        for (y = 0; y < 4; y++)
        {
            for (x = 1; x < 4; x++)
            {
                if (gameData.getTileAtCoord(x,y).value !== 0)
                {
                    if (gameData.getTileAtCoord(x,y).value == gameData.getTileAtCoord(x-1,y).value)
                    {
                        gameData.merge(gameData.indexAtCoord(x,y),gameData.indexAtCoord(x-1,y));
                        tileMoved = true;
                        numberGrid.addScore(gameData.getTileAtCoord(x-1,y).value);
                    }
                }
            }
        }

        //Move everything down again
        for (y = 0; y < 4; y++)
        {
            for (x = 1; x < 4; x++)
            {
                if (gameData.getTileAtCoord(x,y).value !== 0)
                {
                    if (gameData.getTileAtCoord(x-1,y).value === 0)
                    {
                        gameData.swap(gameData.indexAtCoord(x,y),gameData.indexAtCoord(x-1,y));
                        if (x > 1)
                            x -= 2;
                    }
                }
            }
        }

        if (tileMoved)
            afterMove();
    }

    /** MISCELLANEOUS FUNCTIONS **/

    function afterMove ()
    {
        gameData.generate();

        var movesLeft;

        movesLeft = false;

        for (var i = 0; i < 16; i++)
        {
            if (gameData.validMovesLeft(i))
                movesLeft = true;
        }

        if (gameMenu.open)
            gameMenu.open = false;

        if (!movesLeft)
            numberGrid.loss();

        if (gameData.doesTileExist(numberGrid.goal))
            numberGrid.win();
    }
}

