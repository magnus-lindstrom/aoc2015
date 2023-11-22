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
