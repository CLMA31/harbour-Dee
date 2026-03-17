import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.dee 1.0

Page {
    id: page

    property var api
    property int postId
    property string postTitle
    property string postBody
    property string postDate
    property var postData
    property string postAuthor
    property int postScore
    property int postComments

    function loadComments() {
        if (api && postId > 0) {
            var params = JSON.stringify({
                "post_id": postId
            });
            api.listComments(params);
        }
    }

    function loadPostDetails() {
        if (api && postId > 0) {
            api.getPost(postId);
        }
    }

    Component.onCompleted: {
        loadPostDetails();
        loadComments();
        appWindow.postTitle = postTitle;
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: col.height

        PullDownMenu {
            MenuItem {
                text: qsTr("Refresh")
                onClicked: {
                    loadPostDetails();
                    loadComments();
                }
            }
        }

        PushUpMenu {
            MenuItem {
                text: qsTr("Load more")
                enabled: !api.busy
                onClicked: api.loadMoreComments()
            }
        }

        ViewPlaceholder {
            enabled: api && api.comments.length === 0 && !api.busy
            text: qsTr("No comments")
            hintText: qsTr("Pull down to refresh")
        }

        BusyIndicator {
            anchors.centerIn: parent
            size: BusyIndicatorSize.Large
            running: api ? api.busy : false
        }

        VerticalScrollDecorator {}

        Column {
            id: col

            x: Theme.horizontalPageMargin
            width: parent.width - Theme.horizontalPageMargin * 2
            spacing: Theme.paddingMedium

            SectionHeader {}

            Label {
                width: parent.width
                text: postTitle
                color: Theme.primaryColor
                font.pixelSize: Theme.fontSizeMedium
                wrapMode: Text.Wrap
            }

            Label {
                width: parent.width
                text: postBody || ""
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.primaryColor
                visible: postBody && postBody.length > 0
            }

            Label {
                width: parent.width
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeSmall
                horizontalAlignment: Text.AlignRight
                text: postAuthor + " - " + Qt.formatDateTime(postDate, "ddd, hh:mm")
            }

            SectionHeader {
                text: qsTr("Comments") + " (" + (api ? api.comments.length : 0) + "/" + postComments + ")"
            }

            Repeater {
                model: api ? api.comments : []

                delegate: BackgroundItem {
                    property var commentData: modelData.comment || modelData
                    property int depth: {
                        var path = commentData.path || "";
                        return path ? path.split('.').length : 1;
                    }

                    height: commentColumn.height + 2 * Theme.paddingMedium

                    Column {
                        id: commentColumn

                        x: Theme.horizontalPageMargin + (depth > 1 ? (depth - 1) * Theme.paddingLarge : 0)
                        width: parent.width - 2 * Theme.horizontalPageMargin - (depth > 1 ? (depth - 1) * Theme.paddingLarge : 0)
                        spacing: Theme.paddingSmall

                        Label {
                            width: parent.width
                            text: commentData.content || ""
                            color: Theme.secondaryColor
                            font.pixelSize: Theme.fontSizeSmall
                            wrapMode: Text.Wrap
                        }

                        Label {
                            width: parent.width
                            text: {
                                var creator = commentData.creator || modelData.creator || {};
                                var counts = modelData.counts || {};
                                return (creator.name || "") + " - " + (counts.score || 0) + " pts";
                            }
                            font.pixelSize: Theme.fontSizeExtraSmall
                            color: Theme.secondaryColor
                            truncationMode: TruncationMode.Fade
                        }
                    }
                }
            }
        }
    }
}
