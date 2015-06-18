import QtQuick 2.4
import QtGraphicalEffects 1.0
import "colorutils.js" as ColorUtils

Item {
    id: delegateContain

    property int number

    anchors.fill: parent

    scale: number != 0 ? 1 : 0

    Behavior on scale {
        NumberAnimation { easing.type: Easing.InOutQuad }
    }

    Rectangle {
        id: gridDelegate

        anchors {
            fill: parent
            margins: parent.width/40
        }

        radius: width/2

        color: ColorUtils.getBackgroundColor(parent.number)

        Behavior on color {
            ColorAnimation { easing.type: Easing.InOutQuad }
        }

        Text {
            anchors.centerIn: parent
            width: parent.width/Math.SQRT2

            color: ColorUtils.getTextColor(delegateContain.number)

            text: delegateContain.number != 0 ? delegateContain.number : ""
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 0.45*parent.height

            scale: paintedWidth > width ? (width/paintedWidth) : 1

            Behavior on color {
                ColorAnimation { easing.type: Easing.InOutQuad }
            }
        }
    }

    DropShadow {
        source: gridDelegate
        anchors.fill: gridDelegate

        color: "#66000000"

        radius: 8
        samples: 16
        smooth: true
        transparentBorder: true

        verticalOffset: gridDelegate.anchors.margins
    }
}

