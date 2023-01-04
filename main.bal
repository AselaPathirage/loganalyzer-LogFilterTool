import ballerina/io;
import ballerina/file;

# Author - Asela Pathirage (Intern)
#
# Passing the default arguments.
# + input - Log file path
# + output - (Optional) Output file folder location
#
public type Args record {
    string input;
    string? output;
};

public function main(*Args options) returns error? {
    // Initializes the text path and the content.
    string input = options?.input;
    string output = options?.output ?: "FilteredOutput";

    // Gets filename.
    string[] pathArray = check file:splitPath(input);
    string fileName = pathArray[pathArray.length() - 1];

    // Creates a file in the given file path.
    string outputFileName = "filtered_errors_" + fileName;

    // Creates folder if not exists
    boolean dirExists = check file:test(output, file:EXISTS);
    if dirExists is false {
        check file:createDir(output, file:RECURSIVE);
    }
    string outputPath = check file:joinPath(output, outputFileName);

    // Creates file for output
    boolean fileExists = check file:test(outputPath, file:EXISTS);
    if fileExists is true {
        // If file exists remove the file
        check file:remove(outputPath);
    }
    check file:create(outputPath);
    string finalOutput = outputPath;

    // Performs read operation to the file.
    stream<string, io:Error?> lineStream = check io:fileReadLinesAsStream(input);

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
                check io:fileWriteString(finalOutput, val, "APPEND");
            } on fail var e {
                io:println("Error occured in writing to the file. ", e);
            }
            do {
                check io:fileWriteString(finalOutput, "\n", "APPEND");
            } on fail var e {
                io:println("Error occured in writing to the file. ", e);
            }
        }
    });

    io:println("Errors filtered into the file in ", finalOutput);

    if result0 is error {
        io:println("Error occured in writing to the file.");
    }
}
