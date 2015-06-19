import QtQuick 2.4
import QtGraphicalEffects 1.0
import "colorutils.js" as ColorUtils

Item {
    id: goalContain

    property int goal: Math.pow(2,power)
    property int power: 11

    property bool canDecreasePower
    property bool gameActive

    anchors {
        top: parent.top
        right: parent.right
        left: parent.left
    }

    clip: true

    Rectangle {
        id: goalBack

        anchors.centerIn: parent

        height: parent.height*2
        width: height
        radius: width/2

        color: ColorUtils.getBackgroundColor(parent.goal)

        Behavior on color {
            ColorAnimation { easing.type: Easing.InOutQuad }
        }

        Text {
            anchors.centerIn: parent

            font.pixelSize: 0.5*goalContain.height

            color: ColorUtils.getTextColor(goalContain.goal)

            text: goalContain.goal
        }
    }

    FloatingActionButton {
        id: decreasePower

        anchors {
            horizontalCenter: goalBack.left
            verticalCenter: parent.verticalCenter
        }

        z: 10

        small: true
        enabled: (parent.power > 7 && parent.canDecreasePower && parent.gameActive)
        iconName: "decrease"

        onClicked: parent.power--
    }

    FloatingActionButton {
        id: increasePower

        anchors {
            horizontalCenter: goalBack.right
            verticalCenter: parent.verticalCenter
        }

        z: 11

        small: true
        enabled: (parent.power <  14 & parent.gameActive)
        iconName: "increase-white"

        onClicked: parent.power++
    }

    DropShadow {
        source: goalBack
        anchors.fill: goalBack

        radius: 8
        samples: 16
        smooth: true
        transparentBorder: true

        color: "#33000000"

        scale: 1.05
    }
}

