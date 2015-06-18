import QtQuick 2.4
import QtQuick.Window 2.0
import QtQuick.Controls 1.1
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
    }

    NumberGrid {
        id: numGrid

        goal: goalDisplay.goal

        onAddScore: scoreContain.score += diff
        onRestart: scoreContain.score = 0
    }

    Item {
        id: scoreContain

        property int score: 0

        anchors { top: numGrid.bottom; right: parent.right; left: parent.left; bottom: parent.bottom; margins: 10 }

        width: parent.width

        Text {
            id: scoreLabel

            anchors { top: parent.top; horizontalCenter: parent.horizontalCenter; margins: 5 }

            text: "SCORE"
            font.pixelSize: parent.height/5
            font.bold: true

            color: "#000000"
        }

        Text {
            id: scoreDisplay

            anchors { top: scoreLabel.bottom; horizontalCenter: parent.horizontalCenter; margins: 5 }

            text: scoreContain.score
            font.pixelSize: (parent.height - (scoreLabel.height + 5))*0.75
            font.weight: Font.Light

            color: "#000000"
        }
    }
}
