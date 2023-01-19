# ISExceptionFilterTool
Filter out exceptions from the log file. 

Here the ERROR lines and its traces of log file (log filepath should pass as an argument) will be written to a new file.

<h2>Arguments</h2>

input - logfile path

output - (Optional) Output folder location

debug - (Optional) Include the errors in the DEBUG level (Default is false)

warn - (Optional) Include the errors in the WARN level (Default is false)

<h2>To run the .bal file</h2>

<code>bal run \<file\> -- --input=\<logFilePath\> --output=\<outputFolderPath\> --debug=\<true|false\> --warn=\<true|false\></code>

<h2>To build</h2>

<code>bal build</code>

<h2>To run the .jar file</h2>

<code>bal run \<file\> --input=\<logFilePath\> --output=\<outputFolderPath\> --debug=\<true|false\> --warn=\<true|false\></code>
