# Add more folders to ship with the application, here
folder_01.source = qml/2048-qt
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# Stuff to disable OpenGL
DEFINES -= \
    ANDROID_PLUGIN_OPENGL \
    QT_OPENGL_LIB

DEFINES += \
    QT_NO_OPENGL
# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
    gamemodel.cpp \
    gametile.cpp

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

OTHER_FILES += \
    android/AndroidManifest.xml

HEADERS += \
   gamemodel.h \
   gametile.h
