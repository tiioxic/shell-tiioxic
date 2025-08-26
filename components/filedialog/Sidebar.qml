pragma ComponentBehavior: Bound

import ".."
import qs.services
import qs.config
import QtQuick
import QtQuick.Layouts

StyledRect {
    id: root

    required property var dialog

    implicitWidth: Sizes.sidebarWidth
    implicitHeight: inner.implicitHeight + Appearance.padding.normal * 2

    color: Colours.tPalette.m3surfaceContainer

    ColumnLayout {
        id: inner

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: Appearance.padding.normal
        spacing: Appearance.spacing.small / 2

        StyledText {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Appearance.padding.small / 2
            Layout.bottomMargin: Appearance.spacing.normal
            text: qsTr("Files")
            color: Colours.palette.m3onSurface
            font.pointSize: Appearance.font.size.larger
            font.bold: true
        }

        Repeater {
            model: ["Acceuil", "Téléchargements", "Bureau", "Documents", "Musique", "Images", "Vidéos"]

            StyledRect {
                id: place

                required property string modelData
                readonly property bool selected: modelData === root.dialog.cwd[root.dialog.cwd.length - 1]

                Layout.fillWidth: true
                implicitHeight: placeInner.implicitHeight + Appearance.padding.normal * 2

                radius: Appearance.rounding.full
                color: Qt.alpha(Colours.palette.m3secondaryContainer, selected ? 1 : 0)

                StateLayer {
                    color: place.selected ? Colours.palette.m3onSecondaryContainer : Colours.palette.m3onSurface

                    function onClicked(): void {
                        if (place.modelData === "Home")
                            root.dialog.cwd = ["Home"];
                        else
                            root.dialog.cwd = ["Home", place.modelData];
                    }
                }

                RowLayout {
                    id: placeInner

                    anchors.fill: parent
                    anchors.margins: Appearance.padding.normal
                    anchors.leftMargin: Appearance.padding.large
                    anchors.rightMargin: Appearance.padding.large

                    spacing: Appearance.spacing.normal

                    MaterialIcon {
                        text: {
                            const p = place.modelData;
                            if (p === "Acceuil")
                                return "home";
                            if (p === "Téléchargement")
                                return "file_download";
                            if (p === "Bureau")
                                return "desktop_windows";
                            if (p === "Documents")
                                return "description";
                            if (p === "Musique")
                                return "music_note";
                            if (p === "Images")
                                return "image";
                            if (p === "Vidéos")
                                return "video_library";
                            return "folder";
                        }
                        color: place.selected ? Colours.palette.m3onSecondaryContainer : Colours.palette.m3onSurface
                        font.pointSize: Appearance.font.size.large
                        fill: place.selected ? 1 : 0

                        Behavior on fill {
                            Anim {}
                        }
                    }

                    StyledText {
                        Layout.fillWidth: true
                        text: place.modelData
                        color: place.selected ? Colours.palette.m3onSecondaryContainer : Colours.palette.m3onSurface
                        font.pointSize: Appearance.font.size.normal
                        elide: Text.ElideRight
                    }
                }
            }
        }
    }
}
