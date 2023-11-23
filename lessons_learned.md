# Question 20

## My first solution

At first I tried to first iterate over houses, so, start with house nr 1 and calculate how many
presents they got. Then house 2, 3, etc. This involved running 2 loops with the outer one going
i = 1, max_house_nr, and the inner one going j = 1, i. I would check if i was divisible with j at
each step and if it was, add to a presents counter.

As soon as I reached more presents than required, the program finished.

This would have taken hours to run to completion, so I cheesed it and manipulated the starting and
stopping values for the loops manually and re-running many times.

## The better solution

Instead of constantly checking if i is divisible by j, you can just create an array of numbers which
will represent the presents at each house, and simply "act" as each elf in turn and step through the
houses and add the presents. The "downside" of this is that you will deliver many presents to houses
that will end up never being checked anyway, since an earlier house have received enough presents.

This solution is waaaay faster, and runs in seconds.

# Question 22

I started with a breadth first search, creating thousands of game states and adding them to a long
list. That took more than 5 mins to finish.

Opted for depth first (by adding and removing game states from the same end of the list) instead,
which caused the game to finish quickly and me to get a criteria to use when deciding to keep
adding new game states or not. Takes seconds now.

# Question 24

Started by solving in the same way as the two earlier days: using a depth-first search, and then
discarding inferior solutions as I work my way back up the "tree". This solution is in
src/days/24_slow.lua. The b() part takes ages to run. More than 20 minutes at least.

Realized that it must be better to just check for all possible ways to create a third or a fourth of
the total weight of packets. Just work your way up with the number of packets you allow, and as soon
as you find a number that creates solutions, check the smallest qe value.

When implementing this new solution, I found out that it was massively
slower to store all temporary weights in a table and overwriting them over and over, than to just
never store the values in a table to begin with. Sounds obvious now, but the solution went from
perhaps taking an hour to taking <1 sec. So in the final solution, I just fetch the 1 to 6 weights
one by one in an ugly fashion, intead of storing them in a table that can be easily summed up.

# Question 25a

Read the question and INPUT properly...
