const AsyncHandler = require("express-async-handler");
const Cart = require("../models/cartModel");

const addToCart = AsyncHandler(async (req, res) => {
    const { userId, productId, qty } = req.body;
    console.log("Received Data:", { userId, productId, qty });

    const cart = await Cart.create({
        user: userId,
        cartItems: [
            {
                product: productId,
                qty: qty
            }
        ]
    });

    console.log("Created Cart:", cart);

    if (cart) {
        return res.status(201).json({ message: "Cart Added" });
    } else {
        return res.status(400).json({ message: "Cart not added" });
    }
});

const getCartItems = AsyncHandler(async (req, res) => {
    const {userId} = req.body;
    const cartItems = await Cart.find({user:userId});
    if(!cartItems){
        return res.status(404).json({message: "Cart is Empty"});
    }
    return res.status(200).json(cartItems);
});

const updateCart = AsyncHandler(async (req, res) => {
    const {cartId, productId, qty} = req.body;
    const cart = await Cart.findById({_id: cartId});
    if(cart.cartItems.length===0){
        return res.status(404).json({message: "Cart is Empty"});
    }
    const updatedCart = await Cart.updateOne({_id: cartId}, 
        {
            $set: 
            {
                cartItems: 
                [
                    {
                        product: productId, 
                        qty: qty
                    }
                ]
            }
        }
    );
    if(!updatedCart){
        return res.status(400).json({message: "Cart not updated"});
    }
    return res.status(200).json({message: "Cart Updated"});
});

const deleteCartItem = AsyncHandler(async (req, res) => {
    const {userId} = req.body;
    const emptiedCart = await Cart.deleteMany({user: userId});
    if(!emptiedCart){
        return res.status(400).json({message: "Cart not emptied"});
    }
    return res.status(200).json({message: "Cart emptied"});
});

const deleteSingleCartItem = AsyncHandler(async (req, res) => {
    const {cartId} = req.body;
    const deletedItem = await Cart.findByIdAndDelete({ _id: cartId});
    if (!deletedItem) {
        return res.status(404).json({ message: "Cart item not found or not modified" });
    }
    return res.status(200).json({ message: "Cart item deleted" });
});

module.exports = {addToCart, getCartItems, updateCart, deleteCartItem, deleteSingleCartItem};