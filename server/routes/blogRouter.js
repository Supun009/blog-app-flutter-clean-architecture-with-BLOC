const express = require("express");
const auth = require("../midleweare/authMiddle");
const Blog = require("../models/blog");
const blogRout = express.Router();
require('dotenv').config();
const { v2: cloudinary } = require('cloudinary');
const multer = require('multer');

// Multer configuration
const storage = multer.diskStorage({});
const upload = multer({ storage });


 // Configuration
 cloudinary.config({ 
    cloud_name: 'dom13qzxw', 
    api_key: `${process.env.CLOUD_API_KEY}`, 
    api_secret: `${process.env.CLOUD_API}` 
});

blogRout.post('/api/upload', auth, upload.single('image'), async(req, res)=> {
    console.log("hello") 
    try {
        if (!req.file) {
            return res.status(400).send('No file uploaded.');
        }

        cloudinary.uploader.upload(req.file.path, { folder: 'images', resource_type: 'auto' }, async(error, result) => {
            if (error) {
              console.error('Cloudinary upload error:', error);
              return res.status(500).json({ error: 'Cloudinary upload error' });
            }

            const ImageUrl = result.secure_url;

            const { title, topic, content } = req.body 

            let blog = new Blog({
                title: title,
                content : content,
                topics : topic.split(','),
                ImageUrl : ImageUrl,
            });

        // Save song object to MongoDB
        try {
            const savedBlog = await blog.save();
            res.status(200).json({savedBlog});
         } catch (e) {
             res.status(500).json({error: e.message});
         }
        });
        
    } catch (e) {
        res.status(500).json({error: e.message});
    }
});

blogRout.get('/list', auth, async(re, res)=> {
    try {
        const blogList = await Blog.find({});
        console.log(blogList);
        res.status(200).json(blogList);
    } catch (e) {
        res.status(500).json({errr: e.message});
    }
})

module.exports = blogRout;
