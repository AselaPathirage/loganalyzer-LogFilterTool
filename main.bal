import ballerina/io;
import ballerina/file;

# Author - Asela Pathirage (Intern)
#
# Passing the default arguments.
# + input - Log file path
# + output - (Optional) Output file folder location
# + debug - (Optional) Include the errors in the DEBUG level
# + warn - (Optional) Include the errors in the WARN level
#
public type Args record {
    string input;
    string? output;
    string? debug;
    string? warn;
};

public function main(*Args options) returns error? {
    string input = options?.input;
    string output = options?.output ?: "FilteredOutput";
    boolean debug = (options?.debug ?: "false").equalsIgnoreCaseAscii("true") ? true : false;
    boolean warn = (options?.warn ?: "false").equalsIgnoreCaseAscii("true") ? true : false;

    string[] pathArray = check file:splitPath(input);
    string fileName = pathArray[pathArray.length() - 1];

    string outputFileName = "filtered_errors_" + fileName;

    boolean dirExists = check file:test(output, file:EXISTS);
    if dirExists is false {
        check file:createDir(output, file:RECURSIVE);
    }
    string outputPath = check file:joinPath(output, outputFileName);

    boolean fileExists = check file:test(outputPath, file:EXISTS);
    if fileExists is true {
        check file:remove(outputPath);
    }
    check file:create(outputPath);

    stream<string, io:Error?> lineStream = check io:fileReadLinesAsStream(input);

    // Iterates through the stream and prints the content.
    boolean isErrorline = false;
    io:Error? result0 = check lineStream.forEach(function(string val) {
        if (val.startsWith("TID:") && val.includes("] ERROR {")) {
            isErrorline = true;
        } else if (debug && val.startsWith("TID:") && val.includes("] DEBUG {") && val.includes("- Error")) {
            isErrorline = true;
        } else if (warn && val.startsWith("TID:") && val.includes(" WARN {")) {
            isErrorline = true;
        } else if val.startsWith("TID:") {
            isErrorline = false;
        }

        if isErrorline is true {
            do {
                check io:fileWriteString(outputPath, val, "APPEND");
            } on fail var e {
                io:println("Error occured in writing to the file. ", e);
            }
            do {
                check io:fileWriteString(outputPath, "\n", "APPEND");
            } on fail var e {
                io:println("Error occured in writing to the file. ", e);
            }
        }
    });

    io:println("*** Errors filtered into the file in ", outputPath);

    if result0 is error {
        io:println("Error occured in writing to the file.");
    }
}
