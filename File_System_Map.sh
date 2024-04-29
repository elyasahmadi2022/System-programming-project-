#!/bin/bash
echo "Please Enter Name:"
read name;
echo "Please Enter Your Age:"
read age;
echo "Your Name: $name You are about: $age years old"

echo"-----------------------------------------------------"
if [ $age -gt 18 ]
then 
    echo "Mr/Miss $name you are eligiable to vote"
else
    echo "Mr/Miss $name you are not eligiable to vote"
fi

