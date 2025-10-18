'use client'

import React, { useState } from "react";
import { motion, AnimatePresence } from "motion/react";
import { Button } from "@/components/ui/button";
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { cn } from "@/lib/utils";

type Role = "student" | "teacher";

export function AuthForm() {
  const [role, setRole] = useState<Role>("student");
  const [isLogin, setIsLogin] = useState(true);

  const toggleForm = () => setIsLogin(!isLogin);

  const selectedRoleClasses = "bg-primary text-primary-foreground";
  const unselectedRoleClasses = "bg-muted text-muted-foreground hover:bg-muted/80";

  return (
    <Card className="w-[400px] bg-black/50 backdrop-blur-sm border-white/20 text-white">
      <CardHeader className="text-center">
        <CardTitle className="text-2xl">
          {isLogin ? "Welcome Back!" : "Create an Account"}
        </CardTitle>
        <CardDescription className="text-white/70">
          {isLogin
            ? "Sign in to continue your learning journey."
            : "Join us to start your adventure in education."}
        </CardDescription>
      </CardHeader>
      <CardContent>
        <div className="mb-6 grid grid-cols-2 gap-2 rounded-lg bg-muted/50 p-1">
          <Button
            onClick={() => setRole("student")}
            className={cn("rounded-md", role === "student" ? selectedRoleClasses : unselectedRoleClasses)}
          >
            Student
          </Button>
          <Button
            onClick={() => setRole("teacher")}
            className={cn("rounded-md", role === "teacher" ? selectedRoleClasses : unselectedRoleClasses)}
          >
            Teacher
          </Button>
        </div>
        <form>
          <div className="grid w-full items-center gap-4">
            <AnimatePresence mode="popLayout">
              {!isLogin && (
                <motion.div
                  key="name"
                  initial={{ opacity: 0, y: -20 }}
                  animate={{ opacity: 1, y: 0 }}
                  exit={{ opacity: 0, y: -20 }}
                  transition={{ duration: 0.3 }}
                  className="flex flex-col space-y-1.5"
                >
                  <Label htmlFor="name">Full Name</Label>
                  <Input id="name" placeholder="Enter your full name" />
                </motion.div>
              )}
            </AnimatePresence>
            <div className="flex flex-col space-y-1.5">
              <Label htmlFor="email">Email</Label>
              <Input id="email" type="email" placeholder="Enter your email" />
            </div>
            <div className="flex flex-col space-y-1.5">
              <Label htmlFor="password">Password</Label>
              <Input id="password" type="password" placeholder="Enter your password" />
            </div>
          </div>
        </form>
      </CardContent>
      <CardFooter className="flex flex-col gap-4">
        <Button className="w-full bg-yellow-400 text-black hover:bg-yellow-300">
          {isLogin ? `Sign in as a ${role}` : `Sign up as a ${role}`}
        </Button>
        <p className="text-sm text-center text-white/70">
          {isLogin ? "Don't have an account?" : "Already have an account?"}{" "}
          <button onClick={toggleForm} className="font-semibold text-yellow-400 hover:underline">
            {isLogin ? "Sign up" : "Sign in"}
          </button>
        </p>
      </CardFooter>
    </Card>
  );
}