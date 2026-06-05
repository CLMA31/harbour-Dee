import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    property var api

    allowedOrientations: Orientation.All

    Component.onCompleted: {
        if (api && api.loggedIn)
            api.listNotifications();
    }

    function formatAuthor(actorId) {
        if (!actorId)
            return "";
        var parts = actorId.split("/u/");
        if (parts.length < 2)
            return actorId;
        var username = parts[1];
        var urlParts = actorId.split("://");
        var domain = urlParts.length >= 2 ? urlParts[1].split("/")[0] : "";
        return domain ? username + "@" + domain : username;
    }

    Connections {
        target: api
        onNewNotificationsReceived: {}
    }

    SilicaListView {
        id: listView

        anchors.fill: parent
        model: api ? api.notifications : []

        PullDownMenu {
            MenuItem {
                text: qsTr("Home")
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("SubscribedPage.qml"))
            }

            MenuItem {
                text: qsTr("Mark all as read")
                enabled: api ? api.unreadCount > 0 : false
                onClicked: api.markNotificationsRead(-1)
            }

            MenuItem {
                text: qsTr("Refresh")
                onClicked: api.listNotifications()
            }
        }

        header: PageHeader {
            title: api && api.unreadCount > 0 ? qsTr("Inbox (%1)").arg(api.unreadCount) : qsTr("Inbox")
        }

        ViewPlaceholder {
            enabled: listView.count === 0 && (!api || !api.busy)
            text: qsTr("No notifications")
            hintText: qsTr("Pull down to refresh")
        }

        BusyIndicator {
            anchors.centerIn: parent
            size: BusyIndicatorSize.Large
            running: api && api.busy && listView.count === 0
        }

        VerticalScrollDecorator {}

        delegate: ListItem {
            id: delegate

            property var notif: modelData
            property bool isUnread: notif.unread === true
            property string notifType: notif.type || ""

            contentHeight: contentCol.height + 2 * Theme.paddingMedium
            onClicked: {
                if (isUnread)
                    api.markNotificationsRead(notif.id, notif.type);
                if (notifType === "CommentReply" || notifType === "CommentMention" || notifType === "PostMention") {
                    var post = notif.post || {};
                    var community = notif.community || {};
                    var creator = notif.creator || {};
                    pageStack.animatorPush(Qt.resolvedUrl("PostPage.qml"), {
                        "api": api,
                        "community": community.name || "",
                        "postId": post.id || 0,
                        "postTitle": post.name || "",
                        "postBody": post.body || "",
                        "postUrl": post.url || "",
                        "postAuthor": creator.actor_id || "",
                        "postScore": 0,
                        "postDate": post.published || "",
                        "postComments": 0,
                        "postMyVote": 0,
                        "postLocked": post.locked || false
                    });
                }
            }

            Rectangle {
                width: Theme.paddingSmall / 2
                color: Theme.highlightColor
                visible: isUnread
                opacity: 0.8

                anchors {
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }
            }

            Column {
                id: contentCol

                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                spacing: Theme.paddingSmall

                Label {
                    width: parent.width
                    text: {
                        switch (notifType) {
                        case "CommentReply":
                            return qsTr("Reply to your comment");
                        case "PostMention":
                        case "CommentMention":
                            return qsTr("You were mentioned");
                        case "PrivateMessage":
                            return qsTr("Private message");
                        default:
                            return notifType || qsTr("Notification");
                        }
                    }
                    font.pixelSize: Theme.fontSizeSmall
                    color: isUnread ? (delegate.highlighted ? Theme.highlightColor : Theme.primaryColor) : Theme.secondaryColor
                }

                Label {
                    width: parent.width
                    text: {
                        if (notif.comment && notif.comment.content)
                            return notif.comment.content;
                        if (notif.private_message && notif.private_message.content)
                            return notif.private_message.content;
                        if (notif.post && notif.post.name)
                            return notif.post.name;
                        return "";
                    }
                    font.pixelSize: Theme.fontSizeExtraSmall
                    color: delegate.highlighted ? Theme.highlightColor : Theme.secondaryColor
                    wrapMode: Text.Wrap
                    maximumLineCount: 3
                    elide: Text.ElideRight
                    visible: text.length > 0
                }

                Row {
                    width: parent.width
                    spacing: Theme.paddingSmall

                    Label {
                        text: formatAuthor((notif.creator || {}).actor_id || "")
                        font.pixelSize: Theme.fontSizeExtraSmall
                        color: delegate.highlighted ? Theme.highlightColor : Theme.secondaryHighlightColor
                        visible: text.length > 0
                    }

                    Label {
                        text: "·"
                        font.pixelSize: Theme.fontSizeExtraSmall
                        color: delegate.highlighted ? Theme.highlightColor : Theme.secondaryColor
                        visible: formatAuthor((notif.creator || {}).actor_id || "").length > 0
                    }

                    Label {
                        text: notif.published ? Format.formatDate(notif.published, Formatter.DurationElapsed) : ""
                        font.pixelSize: Theme.fontSizeExtraSmall
                        color: delegate.highlighted ? Theme.highlightColor : Theme.secondaryColor
                    }
                }
            }
        }
    }
}
