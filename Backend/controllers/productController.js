const AsyncHandler = require("express-async-handler");
const Product = require("../models/productModel");
const Category = require("../models/categoryModel");

getProducts = AsyncHandler(async (req, res) => {
    const products = await Product.find({});
    return res.status(200).json(products);
});


getProductById = AsyncHandler(async (req, res) => {
    const product = await Product.findById(req.params.id);
    if(product){
        return res.status(200).json(product);
    }else{
        return res.status(404).json({message: "Product not found"});
    }
});


createProduct = AsyncHandler(async (req, res) => {
    const {name, description, price, category, brand, countInStock, image} = req.body;

    if(!name || !description || !price || !category || !brand || !countInStock || !image){
        return res.status(400).json({message: "Please add all fields"});
    }

    const product = await Product.create({
        name,
        description,
        price,
        category,
        brand,
        countInStock,
        image
    });
    const createdProduct = await product.save();
    return res.status(201).json(createdProduct);
});



const updateProduct = AsyncHandler(async (req, res) => {
    const { id } = req.params;
    const updateData = req.body;

    const product = await Product.findById(id);

    if (product) {
        // Update only the fields provided in the request body
        Object.keys(updateData).forEach(key => {
            product[key] = updateData[key];
        });

        const updatedProduct = await product.save();
        return res.status(200).json(updatedProduct);
    } else {
        return res.status(404).json({ message: "Product not found" });
    }
});


deleteProduct = AsyncHandler(async (req, res) => {
    const product = await Product.findById(req.params.id);
    if(product){
        await product.remove();
        return res.status(200).json({message: "Product deleted"});
    }else{
        return res.status(404).json({message: "Product not found"});
    }
});


getTopProducts = AsyncHandler(async (req, res) => {
    const products = await Product.find({}).sort({rating: -1}).limit(3);
    if(!products){
        return res.status(404).json({message: "Products not found"});
    }
    return res.status(200).json(products);
});




createCategory = AsyncHandler(async(req, res)=>{
    const {name} = req.body;
    if(!name){
        return res.status(400).json({message: "Please add all fields"});
    }
    const category = await Category.create({name:name});
    if(category){
        return res.status(201).json(category);
    }
    return res.status(400).json({message: "Category not created"});
});

module.exports = {getProducts, createProduct, updateProduct, deleteProduct, getProductById, getTopProducts, createCategory};