import ballerina/io;
import ballerina/file;
import ballerina/time;

public function main(string filePath) returns error? {
    // Initializes the text path and the content.
    // string textFilePath = "./resources/wso2carbon.log";
    string textFilePath = filePath;

    // Gets time.
    time:Utc timeUTC = time:utcNow();
    string utcString = time:utcToString(timeUTC);

    // Creates a file in the given file path.
    string outputFileName = "errorfile_" + utcString + ".log";
    check file:create(outputFileName);

    // Performs read operation to the file.
    stream<string, io:Error?> lineStream = check io:fileReadLinesAsStream(textFilePath);

    // Iterates through the stream and prints the content.
    boolean isErrorline = false;
    io:Error? result0 = check lineStream.forEach(function(string val) {
        if val.includes("[] ERROR") {
            isErrorline = true;
        } else if val.includes("TID: [] []") {
            isErrorline = false;
        }

        // If line is an error line, log to the file
        if isErrorline is true {
            do {
                check io:fileWriteString(outputFileName, val, "APPEND");
            } on fail var e {
                io:println("Error occured in writing to the file. ", e);
            }
            do {
                check io:fileWriteString(outputFileName, "\n", "APPEND");
            } on fail var e {
                io:println("Error occured in writing to the file. ", e);
            }
        }
    });

    if result0 is error {
        io:println("Error occured in writing to the file.");
    }
}
