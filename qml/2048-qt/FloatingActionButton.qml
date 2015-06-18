import QtQuick 2.4
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0
import "IconResolution.js" as IconSource

Item {
    id: fabContain

    property string iconName
    property bool small: false
    property alias color: fab.color
    property alias enabled: fabTouch.enabled

    signal clicked

    height: small ? Screen.desktopAvailableHeight/15 : Screen.desktopAvailableHeight/10
    width: height

    Rectangle {
        id: fab

        anchors {
            fill: parent
            margins: parent.height/10
        }

        radius: height/2

        color: "#f44336"

        states: State {
            name: "pressed"; when: fabTouch.pressed
            PropertyChanges { target: fab; color: "#c62828" }
        }

        transitions: Transition {
            from: ""; to: "pressed"; reversible: true
            ColorAnimation { duration: 50 }
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

