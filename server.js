const express = require("express");
const fs = require("fs");
const path = require("path");
const app = express();
const PORT = process.env.PORT || 3000;

const GLB_PATH = path.join(__dirname, "output/model.glb");

// Endpoint to check if GLB exists
app.get("/check-glb", (req, res) => {
    if (fs.existsSync(GLB_PATH)) {
        res.json({ status: "created", url: "/model.glb" });
    } else {
        res.json({ status: "not-created" });
    }
});

// Serve GLB file
app.use("/model.glb", express.static(GLB_PATH));

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
