RobotFramework Swinglibrary patch
=================================

`build.sh` will take a SwingLibrary JAR file (downloaded from Google Code)
and splice in a freshly built, newer version, of the Abbot library that is
downloaded from SVN (a specific revision known to work). 

You may amend revisions of SwingLibrary and Abbot to pull from the net in the
`build.sh` script.

The script re-locates the abbot classes into `org.robotframework`, runs sed
scripts to change package references and builds. It then unpacks the
swinglibrary, removes the abbot within and replaces with the abbot just built.

This is used by us with RobotFramework when running Swing applications under
Java 1.7. Previous versions of abbot would cause tests frequently to pause and
then continue having issued a warning something like::

 130207 10:28:25:105 \
 org.robotframework.abbot.tester.Robot.waitForIdle(Robot.java:645):
 Timed out waiting for idle event queue after 957 events

The newer Abbot doesn't have this problem under 1.7 and our tests run smoothly
when this is packaged with SwingLibrary.
