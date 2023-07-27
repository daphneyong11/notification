# Flutter Notification (Firebase and local notification)
A minimal reproducible code sample for flutter plugin firebase messaging (notification) and local notification. 

Problem occured:
When flutter run in release mode, the notification custom sound is not played(foreground, background and terminated state).
When in foreground, the notification icon is not shown (turn into black).
It is noted that when running in debug or profile mode everything is working.
I had tested using real device (Samsung S21).

*Please register your own google-services.json in firebase console and add in android/app folder.
