import QtQuick 2.4
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import "IconResolution.js" as IconSource

Item {
    id: fabContain

    property string iconName
    property bool small: false
    property color color: "#f44336"
    property alias enabled: fabTouch.enabled
    property real windowHeight: Qt.platform.os == "android" ? Screen.desktopAvailableHeight : root.height

    signal clicked

    height: small ? windowHeight/10 : windowHeight/7
    width: height

    Rectangle {
        id: fab

        anchors {
            fill: parent
            margins: parent.height/10
        }

        radius: height/2

        color: parent.color

        states: State {
            name: "pressed"; when: fabTouch.pressed
            PropertyChanges { target: fab; color: Qt.darker(fabContain.color, 1.5) }
        }

        transitions: Transition {
            from: ""; to: "pressed"; reversible: true
            ColorAnimation { duration: 50 }
        }

        Behavior on color {
            enabled: state != "pressed"
            ColorAnimation { easing.type: Easing.InOutQuad }
        }

        RippleTouchArea {
            id: fabTouch

            Component.onCompleted: clicked.connect(fabContain.clicked)
        }

        Image {
            id: icon

            anchors {
                fill: parent
                margins: parent.width*0.2
            }

            opacity: fabTouch.enabled ? 1 : 0.5
            fillMode: Image.PreserveAspectFit
            smooth: true

            source: IconSource.getSource(fabContain.iconName,height)

            Behavior on opacity {
                NumberAnimation { easing.type: Easing.InOutQuad }
            }
        }
    }

    DropShadow {
        anchors.fill: fab

        color: "#aa000000"

        radius: fab.anchors.margins/2
        verticalOffset: radius

        source: fab
        samples: 32
        transparentBorder: true
    }
}

