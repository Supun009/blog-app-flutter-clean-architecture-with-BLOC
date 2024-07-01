const express = require("express");
const authroute = express.Router();
const bcryptjs = require("bcryptjs");
const User = require("../models/user");
const jwt = require("jsonwebtoken");
const auth = require("../midleweare/authMiddle");


authroute.post('/api/signup', async (req, res) =>  {
    try {
        const { name, email, password } = req.body;

        const existingUser = await User.findOne({ email});
        if (existingUser) {
            return res.status(400).json({msg: "User with the same email already exist!"});
        }

        const hashedpassword = await bcryptjs.hash(password, 8);

        let user = new User({
            email,
             password: hashedpassword,
            name,
        });

        user = await user.save();
        res.json(user);

    } catch (e) {
        res.status(500).json({error: e.message});
    }
    
});

authroute.post('/api/login', async (req, res)=> {
    try {
        const {email, password} = req.body;

        const existingUser = await User.findOne({ email});
     
        if (!existingUser) {
            return res.status(400).json({msg: "User with this email dose not exist!"});
        }

        const isMatch = await bcryptjs.compare(password, existingUser.password);

        if (!isMatch) {
            return res.status(400).json({msg: "Incorrect password"})
        }

        const token = jwt.sign({id: existingUser._id}, "passwordkey");
        
        res.json({token, ...existingUser._doc});
    } catch (e) {

        res.status(500).json({error: e.message});
        
    }
})

//get user data
authroute.get('/', auth, async (req, res)=> {
    const user =await User.findById(req.user);
    res.json({...user._doc, token: req.token});
})

module.exports = authroute;