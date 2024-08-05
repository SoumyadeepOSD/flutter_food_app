const mongoose = require("mongoose");

const productSchema = new mongoose.Schema({
    name:{
        type: String,
        required: true
    },
    description:{
        type: String,
        required: true
    },
    price:{
        type: Number,
        required: true
    },
    category:[{
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        ref: 'Category'
    }],
    brand:{
        type: String,
        required: true
    },
    countInStock:{
        type: Number,
        required: true,
        default: 0
    },
    image:{
        type: String,
        required: true
    }
},{
    timestamps: true,
});

const Product = mongoose.model('Product', productSchema);
module.exports = Product;