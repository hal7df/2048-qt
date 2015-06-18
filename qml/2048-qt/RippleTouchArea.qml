import QtQuick 2.4

Item {
    id: touchArea

    property alias pressed: area.pressed
    property alias enabled: area.enabled
    property bool fillParent: false

    readonly property real maxWidth: fillParent ? (width > height ? width*3 : height*3) : width
    readonly property real endX: fillParent ? (-width/2) : 0

    signal clicked
    signal pressAndHold
    signal released

    anchors.fill: parent
    opacity: fillParent ? 1.0 : 0.5
    clip: true

    Rectangle {
        id: ripple

        property real centerX
        property real centerY

        x: centerX - (width/2)
        y: centerY - (height/2)

        radius: width/2
        height: width
        width: 0

        opacity: 0.0
        color: "#b0b0b0"

        ParallelAnimation {
            id: rippleAnimation
            NumberAnimation { target: ripple; property: "opacity"; to: touchArea.opacity; duration: 100 }
            NumberAnimation { target: ripple; property: "width"; to: touchArea.maxWidth; duration: 1000 }
            NumberAnimation { target: ripple; property: "x"; to: touchArea.endX; duration: 1000 }
            NumberAnimation { target: ripple; property: "y"; to: 0; duration: 1000 }
        }

        SequentialAnimation {
            id: fastAnimation

            ParallelAnimation {
                NumberAnimation { target: ripple; property: "opacity"; to: 0.0; duration: 200; easing.type: Easing.InSine }
                NumberAnimation { target: ripple; property: "width"; to: touchArea.maxWidth; duration: 200 }
                NumberAnimation { target: ripple; property: "x"; to: touchArea.endX; duration: 200 }
                NumberAnimation { target: ripple; property: "y"; to: 0; duration: 200 }
            }

            ScriptAction {
                script: {
                    ripple.width = 0;
                }
            }
        }

        ParallelAnimation {
            id: rippleFillAnimation
            NumberAnimation { target: ripple; property: "opacity"; to: touchArea.opacity; duration: 100 }
            NumberAnimation { target: ripple; property: "width"; to: touchArea.maxWidth; duration: 1000 }
            NumberAnimation { target: ripple; property: "x"; to: touchArea.endX; duration: 1000 }
        }

        SequentialAnimation {
            id: fastFillAnimation

            ParallelAnimation {
                NumberAnimation { target: ripple; property: "opacity"; to: 0.0; duration: 200; easing.type: Easing.InSine }
                NumberAnimation { target: ripple; property: "width"; to: touchArea.maxWidth; duration: 200 }
                NumberAnimation { target: ripple; property: "x"; to: touchArea.endX; duration: 200 }
            }

            ScriptAction {
                script: {
                    ripple.width = 0;
                }
            }
        }
    }

    MouseArea {
        id: area

        anchors.fill: parent
        z: 30

        Component.onCompleted: {
            clicked.connect(touchArea.clicked);
            pressAndHold.connect(touchArea.pressAndHold);
            released.connect(touchArea.released);
        }

        onPressAndHold: {
            ripple.centerX = mouse.x;
            ripple.centerY = mouse.y;

            if (parent.fillParent)
                rippleFillAnimation.start();
            else
                rippleAnimation.start();

            mouse.accepted = true;
        }

        onReleased: {
            if (rippleAnimation.running)
            {
                rippleAnimation.stop();
                fastAnimation.start();
            }
            if (rippleFillAnimation.running)
            {
                rippleFillAnimation.stop();
                fastFillAnimation.start();
            }
            else
            {
                ripple.width = 0;
                ripple.opacity = 0.0;
            }
        }
    }
}

