import QtQuick 2.0
import QtQuick.Controls 1.1

Rectangle {
    id: root

    width: 450
    height: 700

    color: "#cecece"

    Item {
        id: goalContain

        property int power: 11
        property int goal: Math.pow(2,power)

        anchors { top: parent.top; right: parent.right; left: parent.left; bottom: numGrid.top }

        Text {
            id: goalDisplay

            text: parent.goal

            font.pixelSize: parent.height/2
            font.weight: Font.Light
            color: "#000000"

            anchors.centerIn: parent
        }

        ToolButton {
            id: decreasePower

            property string iconSize: {
                if (height < 48)
                    return "mdpi";
                else if (height >= 48 && height < 64)
                    return "hdpi";
                else if (height >= 64)
                    return "xhdpi";
            }

            anchors { left: parent.left; verticalCenter: parent.verticalCenter; leftMargin: 5 }

            height: parent.height/2
            width: height

            iconName: "arrow-left"
            iconSource: "images/"+iconSize+"/ic_decrease.png"

            onClicked: {
                if (parent.power > 7 && (numGrid.canDecreasePower))
                    parent.power--;
            }
        }

        ToolButton {
            id: increasePower

            property string iconSize: {
                if (height < 48)
                    return "mdpi";
                else if (height >= 48 && height < 64)
                    return "hdpi";
                else if (height >= 64)
                    return "xhdpi";
            }

            anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: 5 }

            height: parent.height/2
            width: height

            iconName: "arrow-right"
            iconSource: "images/"+iconSize+"/ic_increase.png"

            onClicked: {
                if (parent.power < 14)
                    parent.power++;
            }
        }
    }

    NumberGrid {
        id: numGrid

        goal: goalContain.goal

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
