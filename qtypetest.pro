QT += quick
QT += charts

SOURCES += \
        main.cpp \
        testresults.cpp \
        testresultsmodel.cpp \
        resultssortfilterproxymodel.cpp \
        typingtest.cpp

resources.files = main.qml DetailedTestResults.qml TestInterface.qml TitleBar.qml \
    TestResultsView.qml RadioSelector.qml

resources.prefix = /$${TARGET}
RESOURCES += resources \
    resources.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    dataset.h \
    testresults.h \
    testresultsmodel.h \
    resultssortfilterproxymodel.h \
    typingtest.h

DISTFILES += \
    DetailedTestResults.qml \
    TestInterface.qml
