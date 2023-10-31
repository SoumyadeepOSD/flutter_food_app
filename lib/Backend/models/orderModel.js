const mongoose = require('mongoose');

const orderSchema = mongoose.Schema(
    {
        personal:{
            firstName:{
                type: String,
                required: true
            },
            lastName:{
                type: String,
                required: true
            },
            address:{
                type: String,
                required: true
            },
            pincode:{
                type: String,
                required: true
            },
            mobile:{
                type: String,
                required: true
            }
        },
        order:{
            type: Object,
            required: true
        },
        orderType:{
            type: String,
            required: true
        }
    },
    {
        timestamps: true, 
    }
);

const OrderSchema = mongoose.model('Order', orderSchema);
module.exports = OrderSchema;