import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import QtQuick.Dialogs 1.2

ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("TCP Tool")
    font.family: "Arial,微软雅黑"
    property bool ifExit: false
    Connections {
        target: TcpSocket
        onMessageReceived: {
            historymessage.text += "Server:" + receivedText
            historymessage.text += "\r\n"
        }
    }
    header: ToolBar {
        id: toolbar
        RowLayout {
            spacing: 10
            ToolButton {
                id: toolButton
                contentItem: Image {
                    id: toolbuttonimage
                    sourceSize.height: 20
                    sourceSize.width: 20
                    source: "qrc:/images/menu.png"
                    fillMode: Image.Pad
                }
                onClicked: {
                    console.log(toolbuttonimage.source)
                    if (toolbuttonimage.source.toString(
                                ) === "qrc:/images/menu.png")
                        drawer.open()
                    else {
                        stackview.pop()
                        toolbuttonimage.source = "qrc:/images/menu.png"
                    }
                }
            }
            Label {
                id: title
                text: "TCP Tool"
                font.pointSize: 20
            }
        }
    }
    Drawer {
        id: drawer
        height: parent.height
        width: parent.width / 2
        ListView {
            anchors.fill: parent
            currentIndex: 0
            delegate: ItemDelegate {
                text: model.title
                width: parent.width
                font.family: "Arial,微软雅黑"
                font.pointSize: 16
                onClicked: {
                    if (stackview.depth === 1)
                        stackview.push(model.source)
                    toolbuttonimage.source = "qrc:/images/left-arrow.png"
                    drawer.close()
                }
            }
            model: ListModel {
                ListElement {
                    title: "连接到TCP服务器"
                    source: "qrc:/SettingWindow.qml"
                }
            }
        }
    }
    MessageDialog {
        id: messagedialog
        title: "提示："
        text: "请先连接TCP服务器！"
        standardButtons: StandardButton.Ok
        onAccepted: {
            if (stackview.depth === 1)
                stackview.push("qrc:/SettingWindow.qml")
            toolbuttonimage.source = "qrc:/images/left-arrow.png"
            //close()
        }
    }

    StackView {
        id: stackview
        width: 640
        anchors.rightMargin: 20
        anchors.leftMargin: 20
        anchors.topMargin: 20
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        focus: true
        height: parent.height - 30
        initialItem: ColumnLayout {
            /*
            anchors.leftMargin: 20
            anchors.topMargin: 20
            //botton
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 20
            */
            ScrollView {
                id: scroolview
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                ScrollBar {
                    id: scrollbar
                    function set() {
                        scroolview.ScrollBar.vertical.setPosition(0.1)
                    }
                }

                //clip: true
                TextArea {
                    id: historymessage
                    activeFocusOnPress: false
                    font.pointSize: 20
                    font.family: "Arial, 微软雅黑"
                    readOnly: true
                    anchors.fill: parent
                    onTextChanged: {


                        //console.log(scroolview.ScrollBar.vertical.size)
                        //scroolview.ScrollBar.vertical.setPosition(scroolview.ScrollBar.vertical.size)
                    }
                }
            }
            RowLayout {
                anchors.bottom: parent.button
                anchors.bottomMargin: 20
                TextField {
                    id: sendmessage
                    Layout.fillWidth: true
                    placeholderText: "请输入发送内容:"
                    font.family: "Arial, 微软雅黑"
                    onTextChanged: {
                        if (text === "")
                            sendbutton.enabled = false
                        else
                            sendbutton.enabled = true
                    }
                }
                Button {
                    id: sendbutton
                    text: "发送"
                    font.family: "Arial, 微软雅黑"
                    enabled: false
                    onClicked: {
                        //console.log(tcpsocket.state())
                        if (TcpSocket.state() === 0)
                            messagedialog.open()
                        else {
                            historymessage.text += "Client:" + sendmessage.text
                            historymessage.text += "\r\n"
                            TcpSocket.sendMessage(sendmessage.text)
                            sendmessage.text = ""
                        }
                    }
                }
            }
        }
        onFocusChanged: {
            stackview.focus = true
            //console.log("focus changed")
        }
        Keys.onPressed: {
            if (event.key === Qt.Key_Escape) {
                stackview.pop()
                console.log("pop")
                toolbuttonimage.source = "qrc:/images/menu.png"
            } else if (event.key === Qt.Key_Enter - 1) {
                if (TcpSocket.state() === 0)
                    messagedialog.open()
                else {
                    historymessage.text += "Client:" + sendmessage.text
                    historymessage.text += "\r\n"
                    TcpSocket.sendMessage(sendmessage.text)
                    sendmessage.text = ""
                }
            } else if (event.key === Qt.Key_Back && stackview.depth !== 1) {
                stackview.pop()
                console.log("pop")
                toolbuttonimage.source = "qrc:/images/menu.png"
            } else if (event.key === Qt.Key_Back) {
                if (ifExit) {
                    timer.stop()
                    Qt.quit()
                } else {
                    toast.show("再按一次退出程序")
                    ifExit = true
                    timer.start()
                }
            }
            event.accepted = true
        }

        ToastManager {
            id: toast
        }
        Timer {
            id: timer
            interval: 1000
            onTriggered: {
                ifExit = false
                stop()
            }
        }
    }
}
