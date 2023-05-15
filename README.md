# LogFilterTool

The LogFilterTool is designed to filter log records from a log file based on specified log levels and output the filtered records to a new file.

By default, logs with the **ERROR** level are filtered out, while the other log levels can be passed as arguments as `filters`.

## Arguments

`input` - logfile path

`output` - (Optional) Output folder location

`filters` - (Optional) Log levels divided by commas

## To run the .jar file

```
bal run <file> --input=<logFilePath> --output=<outputFolderPath> --filters=<logLevels>
```

## To run the .bal file

```
bal run <file> -- --input=<logFilePath> --output=<outputFolderPath> --filters=<logLevels>
```

## To build

```
bal build
```


