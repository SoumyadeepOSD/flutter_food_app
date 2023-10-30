const userModel = require('./models/userModel');
const productModel = require('./models/productModel');
const cartModel = require('./models/addCartModel');
const cloudinary = require('cloudinary').v2
const mongoose = require('mongoose');
const jwt = require('jsonwebtoken'); 
const express = require('express');
const dotenv = require('dotenv');
dotenv.config();

const password = encodeURIComponent('Bhowmick@69');
const PORT = 8000;
const URL = `mongodb+srv://SoumyadeepOSD:${password}@cluster0.1i9k0fc.mongodb.net/foody?retryWrites=true&w=majority`;

const app = express();
app.use(express.json());

cloudinary.config({
    cloud_name: process.env.cloud_name,
    api_key: process.env.api_key,
    api_secret: process.env.api_secret,
  });
  

// *Initial Routes*
app.get('/', (req, res) => {
    res.send('Hello World!');
});



// *Register a single user*
app.post('/register', async (req, res, next) => {
    const existingUser = await userModel.findOne({ mobile: req.body.mobile });
    if (existingUser) {
        return res.status(400).json({ message: 'User already exists' });
    } else {
        try {
            const user = await userModel.create(req.body);
           return res.status(200).json(user);
        } catch (error) {
            console.log(error.message);
            return res.status(500).json({ message: error.message });
        }
    }
    next();
});

// *Login user*
app.post('/login', async (req, res, next) => {
    const existingUser = await userModel.findOne({ mobile: req.body.mobile });
    if (existingUser) {
        try {
            return res.status(200).json({ message: "Successfully logged in" });
            next();
        } catch (error) {
            console.log(error.message);
            return res.status(500).json({ message: error.message });
        }
    next();
    } else {
        res.status(400).json({ message: "User is not created" })
    }
});


// *Generate JWT*
app.post('/jwt', async(req, res)=>{
    const { id, mobile } = req.body;
    let jwtSecretKey = process.env.JWT_SECRET_KEY; 
    const token = jwt.sign({id: id, mobile: mobile}, jwtSecretKey); 
    res.send(token); 
});

app.get('/validate', async(req, res)=>{
    let tokenHeaderKey = process.env.TOKEN_HEADER_KEY; 
    let jwtSecretKey = process.env.JWT_SECRET_KEY; 
    try { 
        const token = req.header(tokenHeaderKey); 
        const verified = jwt.verify(token, jwtSecretKey); 
        if(verified){ 
            return res.send("Successfully Verified"); 
        }else{ 
            // Access Denied 
            return res.status(401).send(error); 
        } 
    } catch (error) { 
        // Access Denied 
        return res.status(401).send(error); 
    } 
});

// *Get all users info*
app.get('/home', async (req, res) => {
    try {
        const users = await userModel.find({});
        res.status(200).json(users);
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: error.message });
    }
});


// *Fetch productInfo*
app.get('/products', async (req, res)=>{
    try {
        const products = await productModel.find({});
        res.status(200).json(products);
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: error.message });
    }
});
// //*Send product info*
// app.post('/products', async (req, res)=>{
//     try {
//         const product = await productModel.create(req.body);
//         res.status(200).json(product);
//     } catch (error) {
//         console.log(error);
//         res.status(500).json({ message: error.message });
//     }
// });
// *Add to Cart*
app.post('/cart', async (req, res)=>{
    try {
        const product = await cartModel.create(req.body);
        res.status(200).json(product);
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: error.message });
    }
});

// *View from cart*
app.get('/cart', async (req, res)=>{
    try {
        const mobile = req.query.mobile;
        const product = await cartModel.find({mobile: mobile});
        res.status(200).json(product);
    } catch (error) {
        console.log(error);
        res.status(500).json({ message: error.message });
    }
});


// *Update the number of cart items*
app.put('/cart/:id', async (req, res) => {
    try {
      const cartItemId = req.params.id; // Extract the cart item ID from the URL
      const updatedQuantity = req.body.items; // Assuming the request body contains the new item quantity
  
      // Update the cart item with the new quantity using Mongoose or your preferred MongoDB library
      const updatedCartItem = await cartModel.findByIdAndUpdate(cartItemId, { items: updatedQuantity });
  
      if (updatedCartItem) {
        res.status(200).json(updatedCartItem);
      } else {
        res.status(404).json({ message: 'Cart item not found' });
      }
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: error.message });
    }
  });
  

// *Connect with MongoDB*
async function connect() {
    try {
        mongoose.connect(URL).then(() => {
            console.log('Connected to MongoDB');
        });
    } catch (error) {
        console.log(error);
    }
};
// *Listen to specific port*
app.listen(PORT, () => {
    console.log(`Example app listening on port ${PORT}!`);
});

connect();

