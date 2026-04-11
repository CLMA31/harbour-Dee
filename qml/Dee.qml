import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

ApplicationWindow {
    id: appWindow

    property string postTitle: ""
    property int postScore: 0
    property int postComments: 0

    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations

    initialPage: Component {
        LoginPage {}
    }
}
