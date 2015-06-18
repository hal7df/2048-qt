import QtQuick 2.0
import "colorutils.js" as ColorUtils

Card {
    id: gridDelegate

    property int number

    anchors.fill: parent

    shadowVisible: (number != 0)

    color: ColorUtils.getBackgroundColor(number)

    onVisibleChanged: console.log(visible)
    onColorChanged: console.log(color)

    Text {
        anchors.centerIn: parent
        width: 0.8*parent.width

        color: ColorUtils.getTextColor(parent.number)

        text: parent.number != 0 ? number : ""
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 0.45*parent.height

        scale: paintedWidth > width ? (width/paintedWidth) : 1

        Behavior on color {
            ColorAnimation { duration: gridDelegate.shadowVisible ? 250 : 0; easing.type: Easing.InOutQuad }
        }
    }
}

