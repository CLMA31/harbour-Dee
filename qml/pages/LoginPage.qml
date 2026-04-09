import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.dee 1.0

Page {
    id: page

    property alias api: _api

    allowedOrientations: Orientation.All
    Component.onCompleted: {
        if (_api.loggedIn)
            replaceTimer.start();
    }

    LemmyAPI {
        id: _api
    }

    Timer {
        id: replaceTimer

        interval: 0
        onTriggered: pageStack.replace(Qt.resolvedUrl("SubscribedPage.qml"))
        repeat: false
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge

            PageHeader {
                title: qsTr("Login")
            }

            TextField {
                id: instance

                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                placeholderText: "https://lemmy.world"
                inputMethodHints: Qt.ImhUrlCharactersOnly
                text: _api.instanceUrl
                EnterKey.enabled: text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: username.focus = true
            }

            TextField {
                id: username

                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                placeholderText: qsTr("Email or Username")
                text: _api.username
                EnterKey.enabled: text.length > 0 && instance.text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: password.focus = true
            }

            TextField {
                id: password

                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                placeholderText: qsTr("Password")
                echoMode: TextInput.Password
                EnterKey.enabled: text.length > 0 && username.text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-accept"
                EnterKey.onClicked: _api.login()
            }

            TextField {
                id: totp

                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                placeholderText: qsTr("2-factor authentication")
                inputMethodHints: Qt.ImhDigitsOnly
                EnterKey.enabled: text.length > 0 && username.text.length > 0 && password.text.length > 0
                EnterKey.iconSource: "image://theme/icon-m-enter-accept"
                EnterKey.onClicked: _api.login(instance.text, username.text, password.text, text)
            }

            Button {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                enabled: !_api.busy && instance.text.length > 0 && username.text.length > 0 && password.text.length > 0
                text: _api.busy ? qsTr("Logging in…") : qsTr("Login")
                onClicked: _api.login(instance.text, username.text, password.text, totp.text)
            }

            Label {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                wrapMode: Text.Wrap
                color: _api.error.length > 0 ? Theme.errorColor : Theme.secondaryColor
                text: _api.error
                visible: _api.error.length > 0
            }

            Item {
                width: 1
                height: Theme.paddingLarge
            }
        }
    }

    Connections {

        // Error is already displayed via binding
        target: _api
        onLoginSuccess: {
            pageStack.replace(Qt.resolvedUrl("SubscribedPage.qml"));
        }
        onLoginFailed: {}
    }
}
