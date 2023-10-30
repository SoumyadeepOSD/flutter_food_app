const mongoose = require('mongoose');
const cartSchema = mongoose.Schema(
    {
        mobile:{
            required: true,
            type: String,
        },
        name:{
            type: String,
            required: true
        },
        price:{
            type: Number,
            required: true  
        },
        items:{
            type: Number,
            required: true
        },
        image:{
            type: String,
            required: true
        },
        distance:{
            type: Number,
            required: true
        },
        ratings:{
            type: Number,
            required: true
        }
    }
);

const CartSchema = mongoose.model('cart', cartSchema);
module.exports = CartSchema;