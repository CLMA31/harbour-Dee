import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {
    CoverPlaceholder {
        text: "Dee"
        icon.source: "/usr/share/icons/hicolor/86x86/apps/harbour-dee.png"
        visible: appWindow.postTitle.length === 0
    }

    Column {
        visible: appWindow.postTitle.length > 0
        spacing: Theme.paddingSmall

        anchors {
            left: parent.left
            leftMargin: Theme.paddingSmall
            right: parent.right
            rightMargin: Theme.paddingSmall
            verticalCenter: parent.verticalCenter
        }

        Label {
            width: parent.width
            wrapMode: Text.Wrap
            maximumLineCount: 4
            elide: Text.ElideRight
            font.pixelSize: Theme.fontSizeSmall
            color: Theme.primaryColor
            text: appWindow.postTitle
        }

        Row {
            spacing: Theme.paddingSmall

            Label {
                text: appWindow.postScore + " " + qsTr("pts")
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryHighlightColor
            }

            Label {
                visible: appWindow.postComments > 0
                text: "· " + appWindow.postComments + " " + (appWindow.postComments === 1 ? qsTr("comment") : qsTr("comments"))
                font.pixelSize: Theme.fontSizeExtraSmall
                color: Theme.secondaryColor
            }
        }
    }
}
