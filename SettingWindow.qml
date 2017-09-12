import QtQuick 2.0
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.Material 2.1
import QtQuick.Dialogs 1.2

Item {
	property int tcpstate: 0
	id: item1
	anchors.fill: parent
	Component.onCompleted: {
		if (TcpSocket.state() === 3) {
			ipaddress.text = TcpSocket.ipAddress()
			port.text = TcpSocket.port()
			connectbutton.visible = false
			disconnectbutton.visible = true
		}
	}

	Column {
		id: column
		spacing: 10
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter
		TextField {
			id: ipaddress
			font.family: "Arial, 微软雅黑"
			Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
			placeholderText: "IP地址"
		}
		TextField {
			id: port
			font.family: "Arial, 微软雅黑"
			Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
			placeholderText: "端口"
			Keys.onPressed: {
				if (event.key === Qt.Key_Enter) {
					TcpSocket.connectTcpServer(ipaddress.text, port.text)
					tcpstate = 2
                    event.accepted = true;
				}
			}
		}
		Button {
			id: connectbutton
			text: "连接TCP服务器"
			Layout.minimumWidth: 80
			font.family: "Arial, 微软雅黑"
			Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
			enabled: false
			onClicked: {
				TcpSocket.connectTcpServer(ipaddress.text, port.text)
				tcpstate = 2
				//console.log(TcpSocket.state())
				//stackview.pop()
			}
		}
		Button {
			id: disconnectbutton
			text: "断开连接"
			anchors.horizontalCenter: parent.horizontalCenter
			Layout.minimumWidth: 80
			font.family: "Arial, 微软雅黑"
			Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
			visible: false
			//enabled: false
			onClicked: {
				visible = false
				connectbutton.visible = true
				TcpSocket.disconnectTcpServer()
			}
		}
	}
	ProgressBar {
		id: progressbar
		indeterminate: false
		anchors.right: parent.right
		anchors.rightMargin: 0
		anchors.left: parent.left
		anchors.leftMargin: 0
		anchors.bottom: parent.bottom
		anchors.bottomMargin: 0
	}
	MessageDialog {
		id: dialog
		//standardButtons: StandardButton.Retry
		title: "提示："
		modality: Qt.ApplicationModal
		onAccepted: {
			if (text === "连接成功！") {
				toolbuttonimage.source = "qrc:/images/menu.png"
				stackview.pop()
			}
		}
	}
	Timer {
		id: timer
		interval: 10
		running: true
		repeat: true
		onTriggered: {
			//console.debug((ipaddress.text != "" & port.text != ""))
			if (ipaddress.text != "" && port.text != "") {
				connectbutton.enabled = true
				//console.log(TcpSocket.state())
				if (TcpSocket.state() === 2)
					progressbar.indeterminate = true
				else if (TcpSocket.state() === 3 && disconnectbutton.visible === false) {
					//stackview.pop()
					progressbar.indeterminate = false
					//disconnectbutton.visible = true
					//connectbutton.visible = false
					dialog.text = "连接成功！"
					dialog.standardButtons = StandardButton.Ok
					dialog.open()
					//stackview.pop()
				} else if (TcpSocket.state() === 0
						   && progressbar.indeterminate === true) {
					progressbar.indeterminate = false
					dialog.text = "连接失败！"
					dialog.standardButtons = StandardButton.Retry
					dialog.open()
				}
				state = TcpSocket.state()
			} else
				connectbutton.enabled = false
		}
	}
}
