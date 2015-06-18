import QtQuick 2.3
import QtGraphicalEffects 1.0

Item {

    property bool useSquares: true
    property int number

    GridDelegateCircle {
        number: parent.number
        visible: !parent.useSquares
    }

    GridDelegateSquare {
        number: parent.number
        visible: parent.useSquares
    }
}

