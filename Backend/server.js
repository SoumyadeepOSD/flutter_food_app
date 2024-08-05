const cloudinary = require('cloudinary').v2
const express = require('express');
const dotenv = require('dotenv');
dotenv.config();
const Connect = require("./utils/connectDB.js");
const {notFound,errorHandler} = require("./middlewares/errorMiddleware.js");

// Router
const userRouter = require("./routes/userRoutes.js");
const productRouter = require("./routes/productRoutes.js");
const reviewRouter = require("./routes/reviewRoutes.js");
const cartRouter = require("./routes/cartRoutes.js");

const PORT = 8000;
const app = express();
app.use(express.json());

app.use(express.urlencoded({
    extended: true
}))

// Cloudinary Config
cloudinary.config({
    cloud_name: process.env.CLOUD_NAME,
    api_key: process.env.API_KEY,
});

Connect();

// *Listen to specific port*
app.listen(PORT, () => {
    console.log(`Example app listening on port ${PORT}!`);
});

// *Initial Routes*
app.get('/', (req, res) => {
    res.status(200).json({
        data: 'Hello World!'
    });
});

app.use("/api/user",userRouter);
app.use("/api/products",productRouter);
app.use("/api/reviews", reviewRouter);
app.use("/api/cart", cartRouter);

app.use(notFound);
app.use(errorHandler);



