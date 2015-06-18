import QtQuick 2.4
import "colorutils.js" as ColorUtils

Card {
    id: gridDelegate

    property int number

    anchors.fill: parent

    shadowVisible: (number != 0)

    color: ColorUtils.getBackgroundColor(number)

    Text {
        anchors.centerIn: parent
        width: 0.8*parent.width

        color: ColorUtils.getTextColor(gridDelegate.number)
        visible: gridDelegate.shadowVisible

        text: gridDelegate.number != 0 ? gridDelegate.number : ""
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 0.45*parent.height

        scale: paintedWidth > width ? (width/paintedWidth) : 1

        Behavior on color {
            ColorAnimation { easing.type: Easing.InOutQuad }
        }
    }
}

