#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQuickControls2/QQuickStyle>
#include <QtQml>
#include <tcpsocket.h>

int main(int argc, char *argv[])
{
	TcpSocket tcp;
	QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
	QGuiApplication app(argc, argv);
	QQuickStyle::setStyle("Material");
	QQmlApplicationEngine engine;
	//qmlRegisterType<TcpSocket>("Com.TcpSocket", 1, 0, "TcpSocket");
	engine.rootContext()->setContextProperty("TcpSocket", &tcp);
	engine.load(QUrl(QLatin1String("qrc:/main.qml")));
	if (engine.rootObjects().isEmpty())
		return -1;
	return app.exec();
}
