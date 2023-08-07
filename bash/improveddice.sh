#!/bin/bash
#
# this script rolls a pair of dice with a given number of sides and bias,
# and displays both the rolls, the sum of the dice, and the average of the dice
#

# Task 1:
#  put the number of sides in a variable called `sides`
#  put the bias, or minimum value for the generated number in another variable called `bias`
#  roll the dice using the variables for the range and bias i.e. RANDOM % range + bias

sides=6
bias=1

die1=$(( RANDOM % ${sides} + ${bias} ))
die2=$(( RANDOM % ${sides} + ${bias} ))

# Task 2:
#  generate the sum of the dice
#  generate the average of the dice

sum=$(( die1 + die2 ))
average=$(( sum / 2 ))

# display the results
echo "Rolling..."
echo "Rolled $die1, $die2"
echo "The sum of the dice is $sum"
echo "The average of the dice is $average"
