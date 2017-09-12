#ifndef TCPSOCKET_H
#define TCPSOCKET_H

#include <QObject>
#include <QTcpSocket>
#include <QtNetwork/QTcpSocket>

class TcpSocket : public QObject
{
	Q_OBJECT
	public:
		explicit TcpSocket(QObject *parent = nullptr);
		QTcpSocket tcp;
		Q_INVOKABLE void connectTcpServer(QString ipAddress, QString port);
		Q_INVOKABLE int state();
		Q_INVOKABLE void disconnectTcpServer();
		Q_INVOKABLE QString port();
		Q_INVOKABLE QString ipAddress();
		Q_INVOKABLE void sendMessage(QString message);
	signals:
		void messageReceived(QString receivedText);

	public slots:
		void tcpReadyRead();
};

#endif // TCPSOCKET_H
