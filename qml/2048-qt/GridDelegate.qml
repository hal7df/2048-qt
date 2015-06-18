import QtQuick 2.4
import QtGraphicalEffects 1.0

Item {

    property bool useSquares: false
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

