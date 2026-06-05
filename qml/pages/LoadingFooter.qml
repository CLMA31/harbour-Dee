import QtQuick 2.0
import Sailfish.Silica 1.0

Column {
    property bool busy: false
    property int itemCount: 0

    width: parent ? parent.width : 0
    visible: busy && itemCount > 0

    Item {
        width: parent.width
        height: Theme.paddingLarge
    }

    BusyIndicator {
        anchors.horizontalCenter: parent.horizontalCenter
        size: BusyIndicatorSize.Small
        running: busy
    }

    Label {
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("Loading more…")
        font.pixelSize: Theme.fontSizeExtraSmall
        color: Theme.secondaryColor
    }

    Item {
        width: parent.width
        height: Theme.paddingLarge
    }
}
