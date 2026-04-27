import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    property var api

    allowedOrientations: Orientation.All

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge

        RemorsePopup {
            id: remorseLogout
        }

        VerticalScrollDecorator {}

        Column {
            id: column

            width: page.width
            spacing: 0

            PageHeader {
                title: qsTr("Settings")
            }

            SectionHeader {
                text: qsTr("Account")
            }

            DetailItem {
                label: qsTr("Username")
                value: api.username
            }

            DetailItem {
                label: qsTr("Instance")
                value: api.instanceUrl
            }

            Item {
                width: 1
                height: Theme.paddingLarge
            }

            Button {
                x: Theme.horizontalPageMargin
                width: parent.width - 2 * Theme.horizontalPageMargin
                text: qsTr("Sign out")
                onClicked: {
                    remorseLogout.execute(qsTr("Logging out"), function () {
                        api.logout();
                        pageStack.replace(Qt.resolvedUrl("LoginPage.qml"));
                    });
                }
            }

            Item {
                width: 1
                height: Theme.paddingLarge * 2
            }
        }
    }
}
