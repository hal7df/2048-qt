import QtQuick 2.4
import QtGraphicalEffects 1.0
import "colorutils.js" as ColorUtils

Item {
    id: scoreContainer

    property int score: 0
    property int highscore
    property int curHighTile
    property int highTile

    signal saveScore

    anchors {
        bottom: parent.bottom
        left: parent.left
    }

    onScoreChanged: {
        if (score > highscore)
            highscore = score;
    }

    onCurHighTileChanged: {
        if (curHighTile > highTile)
            highTile = curHighTile;
    }

    Rectangle {
        id: highScoreDisplay

        anchors {
            right: parent.right
            left: curScoreDisplay.right
            verticalCenter: parent.bottom
            leftMargin: -curScoreDisplay.width/10
            rightMargin: parent.width/10
        }

        height: width
        radius: width/2

        color: ColorUtils.getBackgroundColor(highTile)

        states: State {
            name: "pressed"; when: saveHighScoreAction.pressed
            PropertyChanges { target: highScoreDisplay; color: Qt.darker(ColorUtils.getBackgroundColor(highTile), 1.5) }
        }

        transitions: Transition {
            from: ""; to: "pressed"; reversible: true
            ColorAnimation { duration: 50 }
        }

        Behavior on color {
            enabled: state != "pressed"
            ColorAnimation { easing.type: Easing.InOutQuad }
        }

        Text {
            id: highTileText

            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
                topMargin: parent.height/15
            }

            font.pixelSize: parent.height/10

            color: ColorUtils.getTextColor(highTile)

            text: scoreContainer.highTile
        }

        Text {
            id: highScoreText

            anchors {
                top: highTileText.bottom
                horizontalCenter: parent.horizontalCenter
                topMargin: parent.height/20
            }

            width: 2*parent.width/3

            font {
                bold: true
                pixelSize: parent.height/7
            }

            horizontalAlignment: Text.AlignHCenter
            scale: paintedWidth > width ? width/paintedWidth : 1

            color: ColorUtils.getTextColor(highTile)

            text: scoreContainer.highscore
        }

        RippleTouchArea {
            id: saveHighScoreAction

            onClicked: scoreContainer.saveScore()
        }
    }

    DropShadow
    {
        source: highScoreDisplay
        anchors.fill: highScoreDisplay

        radius: 8
        samples: 16
        transparentBorder: true

        scale: 1.25

        color: "#66000000"
    }

    Rectangle {
        id: curScoreDisplay

        anchors {
            right: parent.horizontalCenter
            rightMargin: -parent.height/10
            verticalCenter: parent.verticalCenter
        }

        height: parent.height*1.5
        width: height
        radius: width/2

        color: ColorUtils.getBackgroundColor(parent.curHighTile)

        Behavior on color {
            ColorAnimation { easing.type: Easing.InOutQuad }
        }

        Text {
            id: scoreText

            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: parent.width/6
            }

            width: parent.width/2
            font.pixelSize: parent.height/4
            scale: paintedWidth > width ? width/paintedWidth : 1
            horizontalAlignment: Text.AlignHCenter

            color: ColorUtils.getContrasting(parent.color)

            text: scoreContainer.score
        }

        Text {
            anchors {
                horizontalCenter: scoreText.horizontalCenter
                bottom: scoreText.top
                bottomMargin: scoreText.height/6
            }

            font.pixelSize: parent.height/10

            color: ColorUtils.getContrasting(parent.color)

            text: "SCORE"
        }
    }

    DropShadow {
        source: curScoreDisplay
        anchors.fill: curScoreDisplay

        radius: 8
        samples: 16
        transparentBorder: true

        horizontalOffset: curScoreDisplay.width/50

        color: "#33000000"
    }
}

