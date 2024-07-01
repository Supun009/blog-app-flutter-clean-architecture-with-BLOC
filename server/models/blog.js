const mongoose = require("mongoose");

const blogSchema = mongoose.Schema({
    title: {
        required: true,
        type: String,
    },
    content: {
        required: true,
        type: String,
    },
    ImageUrl: {
        type: String
    },
    topics: {
        require: true,
        type: Array,
    }
});

const Blog = mongoose.model("Blog", blogSchema);

module.exports = Blog;