import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    id: sortDialog
    
    // Current selected sort option
    property string selectedSort
    
    // Available sorting options from Lemmy API
    readonly property list<var> sortOptions: [
        { text: qsTr("New"), value: "New" },
        { text: qsTr("Hot"), value: "Hot" },
        { text: qsTr("Active"), value: "Active" },
        { text: qsTr("Most Comments"), value: "MostComments" },
        { text: qsTr("Top Day"), value: "TopDay" },
        { text: qsTr("Top Week"), value: "TopWeek" },
        { text: qsTr("Top Month"), value: "TopMonth" },
        { text: qsTr("Top Year"), value: "TopYear" },
        { text: qsTr("Top All Time"), value: "TopAll" }
    ]

    DialogHeader {
        title: qsTr("Sort posts")
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingSmall

            ListView {
                id: listView
                width: parent.width
                height: implicitHeight
                model: sortOptions
                clip: true
                
                delegate: ListItem {
                    id: sortItem
                    contentHeight: Theme.itemSizeSmall
                    selected: modelData.value === selectedSort
                    
                    Label {
                        text: modelData.text
                        anchors.centerIn: parent
                        color: sortItem.highlighted ? Theme.highlightColor : Theme.primaryColor
                    }
                    
                    onClicked: {
                        selectedSort = modelData.value;
                        sortDialog.accept();
                    }
                }
            }
        }
    }
}
