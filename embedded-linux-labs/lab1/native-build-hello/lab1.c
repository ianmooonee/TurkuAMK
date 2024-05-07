#include <stdio.h>
#include <time.h>

int main() {
    FILE *outputFile = fopen("output.txt", "a");

    if (outputFile == NULL) {
        fprintf(stderr, "Error opening the output file.\n");
        return 1;
    }

    // Get the current timestamp
    time_t currentTime = time(NULL);
    struct tm *localTime = localtime(&currentTime);
    char timestamp[20];  // Buffer to store the timestamp

    // Format the timestamp
    strftime(timestamp, sizeof(timestamp), "%H:%M:%S", localTime);

    // Print the message to the file
    fprintf(outputFile, "[%s] Hello, World!\n", timestamp);

    fclose(outputFile);
    return 0;  // Exit successfully
}