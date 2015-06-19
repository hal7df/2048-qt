import QtQuick 2.4
import QtQuick.Controls 1.1
import "colorutils.js" as ColorUtils

Card {
    id: numberGrid

    property alias model: playGrid.model
    property int goal
    property int highestNumber: 2
    property bool canDecreasePower: !model.doesTileExist(goal/2)
    property bool active: !gameChangeDisplay.visible

    property bool useSquares

    signal loss
    signal win
    signal restart
    signal continueGame
    signal addScore (int diff)

    height: width

    anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter }

    clip: true
    mainCard: true

    onLoss: gameChangeDisplay.open("You lost!")

    onWin: {
        gameChangeDisplay.open("You won!");

        if (goal < 16384)
            goNextPower.state = "open";
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

        Component.onCompleted: playGrid.forceLayout()

        delegate: GridDelegate {
            width: playGrid.cellWidth
            height: playGrid.cellHeight

            number: value
            useSquares: numberGrid.useSquares
        }
    }

    Rectangle {
        id: gameChangeDisplay

        anchors.fill: parent

        radius: width/2
        color: "#99555555"
        scale: 0

        visible: false
        clip: true

        Text {
            id: gameChangeLabel

            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                topMargin: parent.height/5
            }

            text: ""
            opacity: 0.0

            font.pixelSize: parent.height/6
        }

        FloatingActionButton {
            id: goNextPower

            anchors {
                centerIn: parent
                verticalCenterOffset: height/5
            }

            visible: scale != 0.0
            scale: 0.0

            color: {
                var power;
                power = (Math.log(numberGrid.goal)/Math.log(2))
                power++;

                return ColorUtils.getBackgroundColor(Math.pow(2,power));
            }

            iconName: "increase-"+ColorUtils.getContrasting(color)

            onClicked: {
                gameChangeDisplay.close();
                numberGrid.continueGame();
            }

            states: State {
                name: "open"
                PropertyChanges { target: goNextPower; scale: 1.0 }
            }

            Behavior on scale {
                NumberAnimation { easing.type: Easing.InOutQuad }
            }
        }

        SequentialAnimation {
            id: openDisplay

            ScriptAction {
                script: {
                    gameChangeDisplay.radius = gameChangeDisplay.width/2
                    gameChangeDisplay.scale = 0;
                    gameChangeDisplay.visible = true;
                    gameChangeLabel.opacity = 0.0;
                }
            }
            NumberAnimation { target: gameChangeDisplay; property: "scale"; to: 1.0; easing.type: Easing.InQuad }
            ParallelAnimation {
                PropertyAnimation { target: gameChangeDisplay; property: "radius"; to: 0; easing.type: Easing.OutQuad }
                NumberAnimation { target: gameChangeLabel; property: "opacity"; to: 1.0 }
            }
            ScriptAction {
                script: {
                    gestureMover.focus = true;
                }
            }
        }

        SequentialAnimation {
            id: closeDisplay

            ScriptAction {
                script: {
                    gameChangeDisplay.radius = 0;
                    gameChangeDisplay.scale = 1.0;
                    gameChangeLabel.opacity = 1.0;
                }
            }
            ParallelAnimation {
                PropertyAnimation { target: gameChangeDisplay; property: "radius"; to: gameChangeDisplay.width/2; easing.type: Easing.InQuad }
                NumberAnimation { target: gameChangeLabel; property: "opacity"; to: 0.0 }
            }
            NumberAnimation { target: gameChangeDisplay; property: "scale"; to: 0.0; easing.type: Easing.OutQuad }
            ScriptAction {
                script: {
                    gameChangeDisplay.visible = false;
                    goNextPower.state = "";
                    numberGrid.highestNumber = 2;
                }
            }
        }


        function open (text)
        {
            gameChangeLabel.text = text;
            openDisplay.start();
        }

        function close ()
        {
            closeDisplay.start();
        }
    }

    MultiPointTouchArea {
        id: gestureMover

        property bool actionCompleted: false

        anchors.fill: parent

        maximumTouchPoints: 1
        enabled: !gameChangeDisplay.visible
        focus: true

        onFocusChanged: {
            if (focus)
                console.log("Gesture area gaining focus");
            else
                console.log("Gesture area losing focus");
        }

        onUpdated: {
            if (!actionCompleted)
            {
                var xdiff, ydiff;

                xdiff = touchPoints[0].x - touchPoints[0].startX;
                ydiff = touchPoints[0].y - touchPoints[0].startY;

                if (Math.abs(xdiff) > Math.abs(ydiff))
                {
                    if (xdiff > 30)
                    {
                        actionCompleted = true;
                        numberGrid.moveRight();
                    }
                    else if (xdiff < -30)
                    {
                        actionCompleted = true;
                        numberGrid.moveLeft();
                    }
                }
                else if (Math.abs(xdiff) < Math.abs(ydiff))
                {
                    if (ydiff > 30)
                    {
                        actionCompleted = true;
                        numberGrid.moveDown();
                    }
                    else if (ydiff < -30)
                    {
                        actionCompleted = true;
                        numberGrid.moveUp();
                    }
                }
            }
        }

        onReleased: actionCompleted = false

        Keys.onPressed: {
            if (event.key == Qt.Key_R)
            {
                console.log("Resetting game...");
                numberGrid.resetGame();
                event.accepted = true;
            }
            else if (!gameChangeDisplay.visible)
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
                    console.log("Resetting game...");
                    numberGrid.resetGame();
                }

                else
                {
                    event.accepted = false;
                }
            }
        }
    }

    function resetGame()
    {
        gameData.regenerate();
        gameChangeDisplay.close();
        restart();
        lost = false;
    }

    /** MOVE FUNCTIONS **/

    function moveUp ()
    {
        var x,y;
        var tileMoved;

        tileMoved = false;

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
        var i;
        var highTile;

        movesLeft = false;

        for (i = 0; i < 16; i++)
        {
            if (gameData.validMovesLeft(i))
                movesLeft = true;
        }

        if (!movesLeft)
            numberGrid.loss();

        if (gameData.doesTileExist(numberGrid.goal))
            numberGrid.win();

        highTile = 2;

        for (i = 0; i < 16; i++)
        {
            if (gameData.get(i).value > highTile)
                highTile = gameData.get(i).value;
        }

        highestNumber = highTile;
    }
}

