const fs = require("fs");
const { exec } = require("child_process");
const path = require("path");

const projectRootDirectory = process.cwd();

const elmDirectory = path.join(projectRootDirectory, "src/lib/elm");
const srcDirectory = path.join(elmDirectory, "src");
const outputDirectory = path.join(projectRootDirectory, "static/elm");

process.chdir(elmDirectory);

fs.readdir(srcDirectory, (err, files) => {
  if (err) {
    console.error("Error reading directory:", err);
    return;
  }

  files
    .filter((file) => file.endsWith(".elm"))
    .forEach((file) => {
      const filePath = path.join(srcDirectory, file);
      const outputFilePath = path.join(
        outputDirectory,
        file.replace(".elm", ".js"),
      );
      exec(
        `elm make ${filePath} --output=${path.relative(process.cwd(), outputFilePath)} --optimize`,
        (error, stdout, stderr) => {
          if (error) {
            console.error(`Error executing elm make for ${file}:`, error);
            return;
          }
          console.log(`Compiled ${file} to ${path.relative(projectRootDirectory, outputFilePath)}`);
          console.log(stdout);
        },
      );
    });
});
