import QtQuick 2.4
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import Qt.labs.settings 1.0
import "colorutils.js" as ColorUtils

Rectangle {
    id: root

    width: 450
    height: 700

    color: "#cecece"

    GoalDisplay {
        id: goalDisplay

        anchors {
            bottom: numGrid.top
            bottomMargin: -Screen.desktopAvailableHeight/180
        }

        canDecreasePower: numGrid.canDecreasePower
        gameActive: numGrid.active
    }

    NumberGrid {
        id: numGrid

        z: 30

        goal: goalDisplay.goal
        useSquares: settings.useSquares

        onAddScore: scoreContain.score += diff

        onRestart: {
            restartGame.returnToPlace();
            scoreContain.score = 0;
        }
        onContinueGame: {
            goalDisplay.power++;
            restartGame.returnToPlace();
        }

        onWin: {
            restartGame.x = ((parent.width/2) - (restartGame.width/2));
            restartGame.y = (5*parent.height)/8;
        }

        onLoss: {
            restartGame.x = ((parent.width/2)-(restartGame.width/2))
            restartGame.y = parent.height/2
        }
    }

    ScoreDisplay {
        id: scoreContain

        anchors {
            top: numGrid.bottom
            topMargin: -Screen.desktopAvailableHeight/180
        }

        width: 0.75*parent.width

        curHighTile: numGrid.highestNumber

        onSaveScore: {
            if (scoreContain.highscore > settings.highscore)
                settings.highscore = scoreContain.highscore;
            if (scoreContain.highTile > settings.highTile)
                settings.highTile = scoreContain.highTile;
        }

        Component.onCompleted: {
            highscore = settings.highscore;
            highTile = settings.highTile;
        }

        Component.onDestruction: {
            if (scoreContain.highscore > settings.highscore)
                settings.highscore = scoreContain.highscore;
            if (scoreContain.highTile > settings.highTile)
                settings.highTile = scoreContain.highTile;
        }
    }

    Rectangle {
        id: changeTiles

        anchors {
            right: scoreContain.right
            verticalCenter: scoreContain.verticalCenter
            verticalCenterOffset: -scoreContain.height/6
        }

        height: scoreContain.height/2.5
        width: height
        radius: settings.useSquares ? Screen.desktopAvailableHeight/320 : width/2

        color: ColorUtils.getBackgroundColor(goalDisplay.goal)

        states: State {
            name: "pressed"; when: changeTilesArea.pressed
            PropertyChanges { target: changeTiles; color: Qt.darker(ColorUtils.getBackgroundColor(goalDisplay.goal), 1.5) }
        }

        transitions: Transition {
            from: ""; to: "pressed"; reversible: true
            ColorAnimation { duration: 50 }
        }

        Behavior on radius {
            PropertyAnimation { easing.type: Easing.InOutQuad }
        }

        Behavior on color {
            enabled: state != "pressed"
            ColorAnimation { easing.type: Easing.InOutQuad }
        }

        Text {
            anchors.centerIn: parent

            color: ColorUtils.getTextColor(goalDisplay.goal)

            font.pixelSize: (2*parent.height)/3

            text: "#"
        }

        MouseArea {
            id: changeTilesArea

            anchors.fill: parent

            onClicked: settings.useSquares = !settings.useSquares
        }
    }

    DropShadow {
        source: changeTiles
        anchors.fill: changeTiles

        radius: 8
        samples: 16
        smooth: true
        transparentBorder: true
        color: "#33000000"

        verticalOffset: changeTiles.height/15
    }

    FloatingActionButton {
        id: restartGame

        x: parent.width-width
        y: parent.height-height
        z: 50

        color: ColorUtils.getBackgroundColor(goalDisplay.goal)
        iconName: "reset-"+ColorUtils.getTextColor(goalDisplay.goal)

        onClicked: numGrid.resetGame()

        Behavior on x {
            PropertyAnimation { duration: 500; easing.type: Easing.InOutQuad }
        }

        Behavior on y {
            PropertyAnimation { duration: 500; easing.type: Easing.InOutQuad }
        }

        function returnToPlace ()
        {
            x = parent.width - width
            y = parent.height - height
        }
    }

    Settings {
        id: settings

        property int highscore: 0
        property int highTile: 2
        property bool useSquares: false
    }
}
