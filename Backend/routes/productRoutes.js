const express = require("express");
const router = express.Router();
const {getProducts, createProduct, updateProduct, deleteProduct, getProductById, getTopProducts, createCategory} = require("../controllers/productController");

router.route("/").get(getProducts).post(createProduct);

router.route("/:id").get(getProductById).put(updateProduct).delete(deleteProduct);

router.route("/top").get(getTopProducts);

router.route("/category").post(createCategory);


module.exports = router