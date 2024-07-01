const mongoose = require("mongoose");

const userSchema = mongoose.Schema({
    name: {
        required : true,
        type: String,
        trim: true
    },

    email: {
        required : true,
        type: String,
        trim: true,
        validator : (value) => {
            const res =
            /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
            return value.match(res);
        },
        message: "Please enter a valid email! address",
    },

    password: {
        required : true,
        type: String,
        trim: true,
    },
});

const User = mongoose.model("User", userSchema); 



module.exports = User;