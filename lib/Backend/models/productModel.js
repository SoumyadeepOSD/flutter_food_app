const mongoose = require('mongoose');

const productSchema = mongoose.Schema(
    {
        name:{
            type: String,
            required: true
        },
        price:{
            type: Number,
            required: true
        },
        image:{
            type: String,
            required: true
        },
        type:{
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

const ProductSchema = mongoose.model('products', productSchema);
module.exports = ProductSchema;