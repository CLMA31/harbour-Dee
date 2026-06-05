import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.dee 1.0

Page {
    id: page

    property var api
    property int communityId: 0
    property string communityName: ""
    property bool submitting: false

    function submit() {
        if (titleField.text.trim().length === 0)
            return;
        if (urlField.text.trim().length === 0 && bodyField.text.trim().length === 0)
            return;
        var params = {
            "community_id": communityId,
            "name": titleField.text.trim()
        };
        if (urlField.text.trim().length > 0)
            params.url = urlField.text.trim();
        if (bodyField.text.trim().length > 0)
            params.body = bodyField.text.trim();

        submitting = true;
        api.createPost(JSON.stringify(params));
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
                title: qsTr("Create post")
                description: communityName.length > 0 ? communityName : ""
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                text: qsTr("Title")
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall
            }

            TextField {
                id: titleField

                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                placeholderText: qsTr("Post title")
                enabled: !submitting
                EnterKey.onClicked: urlField.focus = true
            }

            Item {
                width: 1
                height: Theme.paddingMedium
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                text: qsTr("URL") + " (" + qsTr("optional") + ")"
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall
            }

            TextField {
                id: urlField

                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                placeholderText: qsTr("Link (leave empty for a text post)")
                inputMethodHints: Qt.ImhUrlCharactersOnly
                enabled: !submitting
                EnterKey.onClicked: bodyField.focus = true
            }

            Item {
                width: 1
                height: Theme.paddingMedium
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                text: qsTr("Body") + " (" + qsTr("optional") + ")"
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall
            }

            TextArea {
                id: bodyField

                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                placeholderText: qsTr("Write your post…")
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
                text: submitting ? qsTr("Creating…") : qsTr("Create")
                enabled: !submitting && titleField.text.trim().length > 0 && (urlField.text.trim().length > 0 || bodyField.text.trim().length > 0)
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
            if (method === "createPost") {
                titleField.text = "";
                bodyField.text = "";
                urlField.text = "";
                submitting = false;
                pageStack.pop();
            }
        }
        onRequestFailed: {
            if (method === "createPost") {
                errorLabel.text = message;
                submitting = false;
            }
        }
    }
}
