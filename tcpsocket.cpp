#include "tcpsocket.h"
#include <QHostAddress>
#include <QAbstractSocket>
#include <QDebug>
#include <cstdlib>

TcpSocket::TcpSocket(QObject *parent) : QObject(parent)
{
	connect(&tcp, SIGNAL(readyRead()), this, SLOT(tcpReadyRead()));
}

void TcpSocket::connectTcpServer(QString ipAddress, QString port)
{
	tcp.disconnectFromHost();
	tcp.connectToHost(QHostAddress(ipAddress), port.toInt());
	//return tcp.state();
}

int TcpSocket::state()
{
	//Sleep(500);
	return tcp.state();
}

void TcpSocket::disconnectTcpServer()
{
	tcp.disconnectFromHost();
}

QString TcpSocket::port()
{
	return QString::number(tcp.peerPort());
}

QString TcpSocket::ipAddress()
{
	return tcp.peerAddress().toString();
}

void TcpSocket::sendMessage(QString message)
{
	qDebug() << tcp.write(message.toStdString().c_str());
}

void TcpSocket::tcpReadyRead()
{
	qDebug() << "Received";
	QString receivedData(tcp.readAll().toStdString().c_str());
	qDebug() << receivedData;
	emit messageReceived(receivedData);
}
