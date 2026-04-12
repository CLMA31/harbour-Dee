import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.dee 1.0

Page {
    id: page

    property var api
    property int postId
    property int parentId
    property string previewText
    property bool submitting: false

    function submit() {
        if (comment.text.trim().length === 0)
            return;

        submitting = true;
        api.createComment(postId, comment.text.trim(), parentId);
    }

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge

        VerticalScrollDecorator {}

        Column {
            id: column

            width: page.width
            spacing: 0

            PageHeader {
                title: parentId === 0 ? qsTr("Reply to post") : qsTr("Reply to comment")
            }

            Rectangle {
                visible: previewText.length > 0
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                height: quoteLabel.implicitHeight + 2 * Theme.paddingSmall
                color: Theme.rgba(Theme.highlightBackgroundColor, 0.08)
                radius: Theme.paddingSmall

                Rectangle {
                    width: 3
                    height: parent.height
                    color: Theme.secondaryHighlightColor
                    opacity: 0.6
                    radius: 1
                }

                Label {
                    id: quoteLabel

                    x: Theme.paddingMedium + 3
                    y: Theme.paddingSmall
                    width: parent.width - x - Theme.paddingSmall
                    text: previewText
                    wrapMode: Text.Wrap
                    maximumLineCount: 4
                    elide: Text.ElideRight
                    color: Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeSmall
                }
            }

            Item {
                width: 1
                height: Theme.paddingMedium
            }

            TextArea {
                id: comment

                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                focus: true
                placeholderText: qsTr("Write your comment…")
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.Wrap
                enabled: !submitting
            }

            Item {
                width: 1
                height: Theme.paddingMedium
            }

            Button {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                text: submitting ? qsTr("Posting…") : parentId === 0 ? qsTr("Post comment") : qsTr("Reply")
                enabled: !submitting && comment.text.trim().length > 0
                onClicked: submit()
            }

            Label {
                id: errorLabel

                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                topPadding: Theme.paddingSmall
                wrapMode: Text.Wrap
                color: Theme.errorColor
                font.pixelSize: Theme.fontSizeSmall
                visible: text.length > 0
            }
        }
    }

    BusyIndicator {
        anchors.centerIn: parent
        size: BusyIndicatorSize.Large
        running: submitting
    }

    Connections {
        target: api
        onRequestFinished: {
            if (method === "createComment") {
                comment.text = "";
                submitting = false;
                pageStack.pop();
            }
        }
        onRequestFailed: {
            if (method === "createComment") {
                errorLabel.text = message;
                submitting = false;
            }
        }
    }
}
