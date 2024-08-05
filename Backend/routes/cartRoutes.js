const express = require("express");
const router = express.Router();

const {getCartItems, addToCart, updateCart, deleteCartItem, deleteSingleCartItem} = require("../controllers/cartControllers");

router.route("/")
.get(getCartItems)
.put(updateCart)
.post(addToCart)
.delete(deleteCartItem);

router.route("/single", deleteSingleCartItem);


module.exports = router;