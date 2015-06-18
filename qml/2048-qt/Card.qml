import QtQuick 2.4
import QtQuick.Window 2.0

Item {
    id: cardContain

    default property alias cardContents: card.data

    property alias color: card.color
    property alias contentWidth: card.width
    property alias contentHeight: card.height

    property bool mainCard: false
    property bool shadowVisible: true

    Rectangle {
        id: card

        anchors {
            fill: parent
            bottomMargin: parent.mainCard ? Screen.desktopAvailableHeight/180 : anchors.margins
            topMargin: anchors.bottomMargin
            margins: parent.mainCard ? 0 : parent.width/40
        }

        radius: parent.mainCard ? 0 : Screen.desktopAvailableHeight/320

        color: "#ffffff"

        Behavior on color {
            ColorAnimation { easing.type: Easing.InOutQuad }
        }
    }

    Rectangle {

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: card.top
        }

        visible: parent.mainCard

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#00000000" }
            GradientStop { position: 1.0; color: "#33000000" }
        }
    }

    Rectangle {

        anchors {
            top: card.bottom
            left: card.left
            right: card.right
            bottom: parent.bottom

            rightMargin: parent.mainCard ? 0 : card.radius
            leftMargin: anchors.rightMargin
        }

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#33000000" }
            GradientStop { position: 1.0; color: "#00000000" }
        }

        visible: parent.shadowVisible
    }
}

