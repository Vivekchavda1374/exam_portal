const express = require("express");
const app = express();
const bodyP = require("body-parser");
const compiler = require("compilex");
const cors = require("cors"); // Import CORS

const options = { stats: true };
compiler.init(options);

// Middleware
app.use(cors()); // Enable CORS
app.use(bodyP.json());

// Serve HTML for the frontend (if required)
app.get("/", function (req, res) {
  compiler.flush(function () {
    console.log("Deleted temporary files.");
  });
  res.send("Code Compiler Backend is running...");
});

// Compile endpoint for different languages
app.post("/compile", function (req, res) {
  const code = req.body.code;
  const input = req.body.input || "";
  const lang = req.body.lang;

  try {
    if (lang === "Cpp") {
      const envData = { OS: "windows", cmd: "g++", options: { timeout: 10000 } };
      if (!input) {
        compiler.compileCPP(envData, code, function (data) {
          res.json(data.output ? data : { output: "Compilation error or empty output." });
        });
      } else {
        compiler.compileCPPWithInput(envData, code, input, function (data) {
          res.json(data.output ? data : { output: "Compilation error or empty output." });
        });
      }
    } else if (lang === "Java") {
      const envData = { OS: "windows" };
      if (!input) {
        compiler.compileJava(envData, code, function (data) {
          res.json(data.output ? data : { output: "Compilation error or empty output." });
        });
      } else {
        compiler.compileJavaWithInput(envData, code, input, function (data) {
          res.json(data.output ? data : { output: "Compilation error or empty output." });
        });
      }
    } else if (lang === "Python") {
      const envData = { OS: "windows" };
      if (!input) {
        compiler.compilePython(envData, code, function (data) {
          res.json(data.output ? data : { output: "Execution error or empty output." });
        });
      } else {
        compiler.compilePythonWithInput(envData, code, input, function (data) {
          res.json(data.output ? data : { output: "Execution error or empty output." });
        });
      }
    } else {
      res.status(400).send({ output: "Unsupported language." });
    }
  } catch (error) {
    console.error("Error occurred:", error);
    res.status(500).send({ output: "Internal server error." });
  }
});

// Start the server on port 8000
const PORT = 8000;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
