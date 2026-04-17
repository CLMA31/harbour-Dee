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
            font.pixelSize: Theme.fontSizeMedium
            text: appWindow.postTitle
        }

        Label {
            width: parent.width
            color: Theme.secondaryHighlightColor
            font.pixelSize: Theme.fontSizeSmall
            horizontalAlignment: Text.AlignRight
            text: {
                var txt = appWindow.postScore + ' ';
                if (appWindow.postScore === 1)
                    txt += qsTr("point");
                else
                    txt += qsTr("points");
            }
        }

        Label {
            width: parent.width
            color: Theme.secondaryHighlightColor
            font.pixelSize: Theme.fontSizeSmall
            horizontalAlignment: Text.AlignRight
            visible: appWindow.postComments > 0
            text: {
                var txt = appWindow.postComments + ' ';
                if (appWindow.postComments === 1)
                    txt += qsTr("comment");
                else
                    txt += qsTr("comments");
            }
        }
    }
}
