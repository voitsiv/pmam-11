import express from "express";
import cors from "cors";
import { register, login, logout } from "../controllers/auth.js";

const router = express.Router();

router.use("/register", cors());
router.use("/login", cors());
router.use("/logout", cors());

router.post("/register", register);
router.post("/login", login);
router.post("/logout", logout);

export default router;