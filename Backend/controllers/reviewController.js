const Review = require("../models/reviewModel");
const AsyncHandler = require("express-async-handler");


const postReview = AsyncHandler(async(req, res)=>{
    const {user, product, rating, comment} = req.body;
    const review = await Review.create({
        user,
        product,
        rating,
        comment
    });
    await review.save();
    return res.status(201).json({message: "Review Added"});   
});

const getReviews = AsyncHandler(async (req, res) => {
    const { productId } = req.body;
    const reviews = await Review.find({product: productId});
    if(reviews.length===0){
        return res.status(404).json({message: "No reviews found"});
    }
    return res.status(200).json(reviews);
});


const updateReviews = AsyncHandler(async(req, res)=>{
    const {reviewId, comment} = req.body;
    const updatedReview = await Review.updateOne({_id: reviewId},{$set: {comment: comment}});
    if(!updatedReview){
        return res.status(404).json({message: "Can't update Review"});
    }
    return res.status(200).json({message: "Review updated"});
});


const deleteReviews = AsyncHandler(async(req, res)=>{
    const {reviewId} = req.body;
    const deletedReview = await Review.deleteOne({_id: reviewId});
    if(!deletedReview){
        return res.status(404).json({message: "Can't delete Review"});
    }
    return res.status(200).json({message: "Review deleted"});
});

module.exports = {postReview, getReviews, updateReviews, deleteReviews};